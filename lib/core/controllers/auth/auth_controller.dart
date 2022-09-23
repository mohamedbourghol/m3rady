import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m3rady/core/helpers/dio_helper.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/users/social/social_login.dart';
import 'package:m3rady/core/models/users/user.dart' as UserModel;
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Set social providers
enum SocialProvider {
  google,
  apple,
}

class Authentication {
  /// Set login screen route
  static String loginScreenRoute = '/auth/login';

  static var _phoneAuthCredential;
  static var _verificationId;
  static var firebaseUser;

  //// Generates a cryptographically secure random nonce, to be included in a
  //// credential request.
  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  //// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Anonymous Auth
  static Future signInAnonymouslyCredentials() async {
    /// Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInAnonymously();
  }

  /// Phone Auth
  static Future signInPhoneCredentials(
    String phone, {
    String? code,
    codeSentCallback,
    verificationCompletedCallback,
    verificationFailedCallback,
  }) async {
    try {
      if (code != null) {
        _phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: code);

        /// Authenticate
        await FirebaseAuth.instance
            .signInWithCredential(_phoneAuthCredential)
            .then((auth) {
          firebaseUser = auth.user;
          if (config['isDebugMode']) print(auth.user?.phoneNumber);
        });

        /// If authenticated
        if (firebaseUser != null) {
          return true;
        }
      } else {
        /// Reset all
        firebaseUser = null;
        _phoneAuthCredential = null;
        _verificationId = null;

        //// The below functions are the callbacks, separated so as to make code more readable
        void verificationCompleted(AuthCredential phoneAuthCredential) async {
          if (config['isDebugMode']) print('verificationCompleted');
          _phoneAuthCredential = phoneAuthCredential;

          if (verificationCompletedCallback != null) {
            await verificationCompletedCallback();
          }

          /// Stop loading
          MainLoader.set(false);

          if (config['isDebugMode']) print(phoneAuthCredential);
        }

        void verificationFailed(error) async {
          if (config['isDebugMode']) print('verificationFailed');

          if (verificationFailedCallback != null) {
            await verificationFailedCallback();
          }

          /// Stop loading
          MainLoader.set(false);

          if (config['isDebugMode']) print(error);
        }

        void codeSent(String verificationId, [int? code]) async {
          _verificationId = verificationId;

          if (codeSentCallback != null) {
            await codeSentCallback();
          }

          /// Stop loading
          MainLoader.set(false);

          if (config['isDebugMode']) print('codeSent');
        }

        void codeAutoRetrievalTimeout(String verificationId) {
          if (config['isDebugMode']) print('codeAutoRetrievalTimeout');
        }

        await FirebaseAuth.instance.verifyPhoneNumber(
          //// Make sure to prefix with your country code
          phoneNumber: phone,

          //// `seconds` didn't work. The underlying implementation code only reads in `milliseconds`
          timeout: Duration(milliseconds: 10000),

          //// If the SIM (with phoneNumber) is in the current device this function is called.
          //// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
          verificationCompleted: verificationCompleted,

          //// Called when the verification is failed
          verificationFailed: verificationFailed,

          //// This is called after the OTP is sent. Gives a `verificationId` and `code`
          codeSent: codeSent,

          //// After automatic code retrival `tmeout` this function is called
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        );

        /// All the callbacks are above
      }
    } catch (e) {
      if (config['isDebugMode']) print(e);
      return false;
    }
  }

  /// Google Auth
  static Future<UserCredential> signInWithGoogleCredentials() async {
    /// Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    /// Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    /// Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    /// Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Apple Auth
  static Future<UserCredential> signInWithAppleCredentials() async {
    /// To prevent replay attacks with the credential returned from Apple, we
    /// include a nonce in the credential request. When signing in with
    /// Firebase, the nonce in the id token returned by Apple, is expected to
    /// match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    /// Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.fullName,
        AppleIDAuthorizationScopes.email,
      ],
      nonce: nonce,
    );

    /// Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    /// Sign in the user with Firebase. If the nonce we generated earlier does
    /// not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  /// Get user auth token form storage
  static Future getUserAuthToken() async {
    /// Get user language code from storage
    bool isUserAuthenticated =
        await LocalStorage.get('isUserAuthenticated') == true;

    /// Get user auth token from storage
    String userAuthenticationToken = (isUserAuthenticated
        ? (await LocalStorage.get('userAuthenticationToken') ?? '')
        : '');

    return (isUserAuthenticated == true ? userAuthenticationToken : false);
  }

  /// Set user auth token form storage
  static Future setAuthToken(token) async {
    await LocalStorage.set('isUserAuthenticated', true);

    await LocalStorage.set('userAuthenticationToken', token);

    /// Init APIs
    await DioHelper.init();

    return token;
  }

  /// Set user type form storage
  static Future setUserType(type) async {
    await LocalStorage.set('userType', type);

    return type;
  }

  /// Get user type form storage
  static Future getUserType() async {
    return await LocalStorage.get('userType') ?? 'guest';
  }

  /// Set and get user data
  static Future setAndGetUserData() async {
    /// Get user data
    var data = await getUserData(force: true);
          print("data");
    print(data);
    print("data");
    /// Set user data
    if (data != false) {
      //await LocalStorage.set('userData', data);
      GlobalVariables.user = data;
      GlobalVariables.userDataUpdatesCounter.value++;
      GlobalVariables.isUserAuthenticated.value = true;
    }

    return data;
  }

  /// Get user data
  static Future getUserData({force = false}) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var storageData = GlobalVariables.user;
    //await LocalStorage.get('userData');

    if (force == false &&
        storageData != null &&
        storageData != false &&
        storageData != []) {
      return storageData;
    }

    /// Send request
    return await UserModel.User.getUserData();
  }

  /// Unset user auth token form storage
  static Future unsetAuthToken() async {
    /// Set user data
    GlobalVariables.user = null;
    GlobalVariables.userDataUpdatesCounter.value = 0;
    GlobalVariables.isUserAuthenticated.value = false;

    await LocalStorage.set('isUserAuthenticated', false);

    await LocalStorage.set('userAuthenticationToken', '');

    /// Set user type to guest
    await setUserType('guest');

    /// Init APIs
    await DioHelper.init();
  }

  /// Get fcm token form storage
  static Future getFCMToken() async {
    try{
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    }
    catch(e)
    {
      return '';
    }
  }

  /// Login with account
  static Future loginAccount({
    required String login,
    required String password,
  }) async {
    /// Start loader
    MainLoader.set(true);

    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    /// Get fcm token
    String fcmToken = await getFCMToken();

    /// Send request
    var auth = await UserModel.User.loginAccount(
      login: login,
      password: password,
      fcmToken: fcmToken,
    );
         print(auth);
    /// Stop loader
    MainLoader.set(false);
    return await loginUser(auth);
  }

  /// Login with social
  static Future loginSocial({
    required SocialProvider provider,
  }) async {
    /// Start loader
    MainLoader.set(true);

    /// Set auto show errors
    await AppServices.setAutoShowErrors(false);

    /// Set Credentials
    var credentials;

    /// Set Credentials
    var providerId;

    /// Set providerStr
    var providerStr;

    /// Set auth
    var auth;

    /// Get credentials
    if (provider == SocialProvider.google) {
      providerStr = 'google';
      credentials = await signInWithGoogleCredentials();
      providerId = credentials.user?.uid;
    } else if (provider == SocialProvider.apple) {
      providerStr = 'apple';
      credentials = await signInWithAppleCredentials();
      providerId = credentials.user?.uid;
    }

    /// Get fcm token
    String fcmToken = await getFCMToken();

    /// Send request
    if (providerStr != null && providerId != null) {
      auth = await UserModel.User.loginSocial(
        provider: providerStr,
        providerId: providerId,
        fcmToken: fcmToken,
      );
    }

    /// Stop loader
    MainLoader.set(false);

    return await loginUser(auth);
  }

  /// Get  social data
  static Future getSocialData({
    required SocialProvider provider,
  }) async {
    /// Start loader
    MainLoader.set(true);

    /// Set Credentials
    var credentials;

    /// Set Credentials
    var providerId;

    /// Set providerStr
    var providerStr;

    /// Get credentials
    if (provider == SocialProvider.google) {
      providerStr = 'google';
      credentials = await signInWithGoogleCredentials();
      providerId = credentials.user?.uid;
    } else if (provider == SocialProvider.apple) {
      providerStr = 'apple';
      credentials = await signInWithAppleCredentials();
      providerId = credentials.user?.uid;
    }

    /// Stop loader
    MainLoader.set(false);

    if (providerStr != null && providerId != null) {
      return SocialLogin(
        provider: providerStr,
        providerId: providerId,
      );
    }

    return false;
  }

  /// login user with auth data
  static Future loginUser(auth) async {
    /// Start loader
    MainLoader.set(true);

    /// if authenticated
    if (auth != false) {
      /// Set auth token
      await setAuthToken(auth['token']);

      /// Get and set user data
      await setUserType(auth['user']['type']);

      /// Get and set user data
      var userData = await setAndGetUserData();

      /// Ping user
      await UserModel.User.pingUser();

      /// Stop loader
      MainLoader.set(false);

      return userData;
    }

    /// Stop loader
    MainLoader.set(false);

    return false;
  }

  /// login user with auth data
  static Future registerUser({
    required type,
    required name,
    businessTypeId,
    required mobile,
    email,
    username,
    required password,
    required countryCode,
    required cityId,
    isAcceptedSendNotifications,
    mobileVerificationCode,
    isRequestMobileVerificationCode,
  }) async {
    /// Get fcm token
    String fcmToken = await getFCMToken();

    /// Send request
    var auth = await UserModel.User.register(
      type: type,
      name: name,
      businessTypeId: businessTypeId,
      mobile: mobile,
      email: email,
      username: username,
      password: password,
      countryCode: countryCode,
      cityId: cityId,
      fcmToken: fcmToken,
      isAcceptedSendNotifications: isAcceptedSendNotifications,
      mobileVerificationCode: mobileVerificationCode,
      interestedCategories:{},
      isRequestMobileVerificationCode: isRequestMobileVerificationCode,
    );

    return await loginUser(auth);
  }

  /// check authentication
  static Future check({
    unAuthenticateUserIfFaild: false,
    setUserData: false,
  }) async {
    var check = await UserModel.User.check();

    //unauthenticate user if faild
    if (check == false && unAuthenticateUserIfFaild) {
      /// Unset token
      await unsetAuthToken();
    }

    /// Set user data
    if (check != false && setUserData == true) {
      /// Get user data
      await Authentication.setAndGetUserData();
    }

    return check;
  }

  /// logout
  static Future logout({
    bool redirectLogin: true,
    bool showReLoginDialog: true,
  }) async {
    var user = await check();
    if (user != false) {
      /// Send logout request
      await UserModel.User.logout();
    }

    //// Method to Logout the `FirebaseUser` (`firebaseUser`)
    try {
      /// signout code
      await FirebaseAuth.instance.signOut();
      firebaseUser = null;
    } catch (e) {
      if (config['isDebugMode']) print(e);
    }

    /// Unset token
    await unsetAuthToken();

    /// redirect login
    if (redirectLogin == true && Get.currentRoute != loginScreenRoute) {
      await Get.offAllNamed(loginScreenRoute);
    }

    /// show dialog
    if (showReLoginDialog == true) {
      Get.defaultDialog(
        title: 'Warning'.tr,
        middleText: '',
        backgroundColor: Colors.white,
        titleStyle: TextStyle(
          color: Colors.redAccent,
          fontSize: 14,
        ),
        middleTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        cancelTextColor: Colors.black38,
        buttonColor: Colors.white,
        textCancel: 'Agree'.tr,
        barrierDismissible: false,
        radius: 25,
        content: Text('Please re login again.'.tr),
      );
    }
  }
}
