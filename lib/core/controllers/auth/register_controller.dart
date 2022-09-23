import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/controllers/system/countries/countries_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

import '../../view/screens/shared/auth/register/verify_mobile.dart';
import '../categories/categories_controller.dart';

/// GetxController disposable interface (remove form stack)
class RegisterController extends GetxController {
  CategoriesController categoriesController = Get.put(CategoriesController());
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileVerifyFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController mobileFullController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController mobileVerificationCodeController =
      TextEditingController();

  PhoneNumber mobileNumber = PhoneNumber();
  Map selectedInterestedCategories = {};
  bool passwordVisibility = false;
  bool passwordConfirmationVisibility = false;
  bool isAgreeToPolicies = false;
  bool isAgreeToSendNotifications = true;
  bool isMobileVerifyHasError = false;
  bool isVerifyingMobile = false;
  var verifyingResendCodeTimer;
  int verifyingResendCodeTimerValue = 0;
  int resendMobileVerificationCodeTimes = 0;
  Map categories = {};
  var accountType;
  var registrationData;
  var provider;
  var providerId;

  Map countries = {};
  Map cities = {};
  var selectedCountryCode = GlobalVariables.userGeoIpCountryCode;
  var selectedCityId;

  @override
  void onReady() async {
    super.onReady();




    /// Get and set countries
    await getAndSetCountries();
    categories = await categoriesController.getCategories();
  }

/*
 * Get And Set Countries (API)
 */
  Future getAndSetCountries() async {
    AppCountries countriesController = Get.find<AppCountries>();

    /// Get countries
    countries = countriesController.countries;

    if (selectedCountryCode != null &&
        countries.containsKey(selectedCountryCode)) {
      getAndSetCitiesByCountryCode(selectedCountryCode);
    } else {
      selectedCountryCode = null;
    }

    update();
  }

/*
 * Get And Set cities By Country Code (API)
 */
  Future getAndSetCitiesByCountryCode(code) async {
    /// Get cities
    if (countries.containsKey(code)) cities = countries[code]!.cities!;

    update();
  }

  /*
   * Check Mobile Verification Code
   */
  /*Future checkMobileVerificationCode() async {
    setIsVerifyingMobile(true);

    String code = mobileVerificationCodeController.text;
    bool isValidCode = code.length == 4;

    /// Set error state
    setIsMobileVerifyHasError(!isValidCode);

    await Future.delayed(Duration(seconds: 3), () async {});

    setIsVerifyingMobile(false);

    return isValidCode;
  }*/

/*
 * Set is verifying mobile
 */
  void setIsVerifyingMobile(bool isVerifying) {
    isVerifyingMobile = isVerifying;
    update();
  }

/*
 * Set Is Mobile Verify Has Error
 */
  void setIsMobileVerifyHasError(bool isHasError) {
    isMobileVerifyHasError = isHasError;
    update();
  }

/*
 * Toggle password visibility
 */
  void togglePasswordVisibility() {
    passwordVisibility = !passwordVisibility;
    update();
  }

/*
 * Toggle password confirmation visibility
 */
  void togglePasswordConfirmationVisibility() {
    passwordConfirmationVisibility = !passwordConfirmationVisibility;
    update();
  }

/*
 * Change the selected country
 */
  void changeSelectedCountry(code) async {
    print(code);
    if (selectedCountryCode != code) {
      selectedCountryCode = code;

      /// Remove selected city
      selectedCityId = null;

      /// Get cities form current country
      await getAndSetCitiesByCountryCode(code);
    }

    update();
  }

  /*
 * Change the selected city
 */
  void changeSelectedCity(id) async {
    selectedCityId = id.toString();
    update();
  }

/*
 * Set Is Agree To Policies
 */
  void setIsAgreeToPolicies(value) {
    isAgreeToPolicies = value == true;
    update();
  }

/*
 * Toggle Is Agree To Policies
 */
  void toggleIsAgreeToPolicies() {
    isAgreeToPolicies = !isAgreeToPolicies;
    update();
  }

/*
 * Set Is Agree To Send Notifications
 */
  void setIsAgreeToSendNotifications(value) {
    isAgreeToSendNotifications = value == true;
    update();
  }

/*
 * Toggle Is Agree To Send Notifications
 */
  void toggleIsAgreeToSendNotifications() {
    isAgreeToSendNotifications = !isAgreeToSendNotifications;
    update();
  }

/*
 * Validate form
 */
  bool validateForm() {
    FormState? form = registerFormKey.currentState;
    if (form != null) {
      return form.validate();
    }
    return false;
  }

/*
 * Check if the user is not accepted the polices and alert him
 */
  bool checkAndAlertToAcceptPolices() {
    /// Alert if not accepting the polices
    if (!isAgreeToPolicies) {
      Get.defaultDialog(
        title: 'Warning'.tr,
        titleStyle: TextStyle(
          color: Colors.redAccent,
          fontSize: 14,
        ),
        content: Center(
          child: Text(
            'You must agree to the polices to register.'.tr,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        confirm: TextButton(
          child: Text('Ok'.tr),
          onPressed: () => Get.back(),
        ),
      );
    }

    return isAgreeToPolicies;
  }

  /*
   * Start send mobile verification code timer
   */
  void startSendMobileVerificationCodeTimer() {
    ///  If timer ends
    if (verifyingResendCodeTimerValue <= 0) {
      /// Set verifying resend code timer (add 30 second every time)
      verifyingResendCodeTimerValue =
          (60 + 30 * resendMobileVerificationCodeTimes);

      //Set times
      resendMobileVerificationCodeTimes++;

      /// If previous timer
      if (verifyingResendCodeTimer != null) {
        verifyingResendCodeTimer!.cancel();
      }

      /// Start countdown timer
      verifyingResendCodeTimer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) {
          if (verifyingResendCodeTimerValue > 0) {
            verifyingResendCodeTimerValue--;
          } else {
            timer.cancel();
          }

          /// Update
          update();
        },
      );

      /// Update
      update();
    }
  }

  /// Get fcm token form storage
  static Future getFCMToken() async {
    return await LocalStorage.get('fcmToken') ?? '';
  }

  /// Send mobile verification code
  Future sendMobileVerificationCode(context) async {
    return await register(
      reSetRegistrationData: false,
      isRequestMobileVerificationCode: true,
      go: (){}
    );
  }



  /// Register user
  Future register({
    reSetRegistrationData = true,
    accountType,
    String? mobileVerificationCode,
    isRequestMobileVerificationCode = false,
      required VoidCallback go,
   bool useFirebase=false
  }) async {
    print(mobileFullController.text);
    /// Set account type
    if (accountType != null) {
      this.accountType = accountType;
    }

    /// If mobile verification code exists
    if (mobileVerificationCode != null &&
        mobileVerificationCode.length == 6 &&
        (!selectedCountryCode.contains('SA')||useFirebase)) {
      await Authentication.signInPhoneCredentials(
        mobileFullController.text.trim(),
        code: mobileVerificationCode,
      );
    }

    /// Validate form
    if (validateForm() && checkAndAlertToAcceptPolices()) {
      /// Set registration data
      if (reSetRegistrationData == true || registrationData == null) {
        registrationData = {
          'type': (this.accountType['id'] == 'customer'
              ? 'customer'
              : 'advertiser'),
          'businessTypeId': (this.accountType['id'] == 'customer'
              ? null
              : this.accountType['id']),
          'name': nameController.text.trim(),

          'mobile': mobileFullController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'countryCode': selectedCountryCode,
          'cityId': selectedCityId,
          'provider': provider,
          'providerId': providerId,
          'fcmToken': await getFCMToken(),
          'isAcceptedSendNotifications': isAgreeToSendNotifications,
        };
      }

      /// Send request
      if (registrationData != null) {
        /// Start loader
        MainLoader.set(true);

        /// Send request
        var user = await User.register(
          type: registrationData['type'],
          businessTypeId: registrationData['businessTypeId'],
          name: registrationData['name'],
          mobile: registrationData['mobile'],
          email: registrationData['email'],
          password: registrationData['password'],
          countryCode: registrationData['countryCode'],
          cityId: registrationData['cityId'],
          fcmToken: registrationData['fcmToken'],
          interestedCategories: selectedInterestedCategories,
           username: registrationData['name'],
          mobileVerificationCode: mobileVerificationCode,
          isRequestMobileVerificationCode:
          isRequestMobileVerificationCode,
          isAcceptedSendNotifications:
              registrationData['isAcceptedSendNotifications'],
          provider: registrationData['provider'],
          providerId: registrationData['providerId'],
        );

        /// Stop loader
        MainLoader.set(false);

        /// If no issues
        if (user != false) {
          /// is mobile verification code has been sent
          if (user?['isMessageSent'] != null && user['isMessageSent'] == true) {
            /// If request to send code
            if (isRequestMobileVerificationCode == true &&
                (verifyingResendCodeTimerValue == 0 ||
                    Get.currentRoute.toString() !=
                        '/auth/register/mobile/verify')) {

              /// Reset field
              mobileVerificationCodeController.clear();

              /// Send code
              if(!selectedCountryCode.contains('SA'))
                CConfirmDialog(
                content:
                    "You might need to prove that you are not a robot to register! You will be redirected to the validation after confirmation."
                        .tr,
                confirmText: 'Confirm'.tr,
                confirmTextColor: Colors.green,
                confirmCallback: () async {




                     {MainLoader.set(true);
                       print('2');
                       await Authentication.signInPhoneCredentials(
                         mobileFullController.text.trim(),
                         codeSentCallback: () async {
                           /// Start timer
                          // startSendMobileVerificationCodeTimer();

                           /// Go to mobile verification screen
                           if (Get.currentRoute.toString() !=
                               '/auth/register/mobile/verify') {
                             Get.toNamed('/auth/register/mobile/verify');
                           }
                         },
                         verificationFailedCallback: () {
                           /// Show error
                           CErrorDialog(errors: [
                             'Verification failed, please try again!'.tr
                           ]);

                           /// Set mobile has error
                           setIsMobileVerifyHasError(true);
                         },
                       );
                     }


                },
              );
              else
                go();

              /// Stop loading
              MainLoader.set(false);
            }
          } else if (user?['token'] != null) {
            /// Start loader
            MainLoader.set(true);

            /// Login user
            var userData = await
            Authentication.loginUser(user);

            /// Stop loader
            MainLoader.set(false);

            /// Redirect to home
            if (userData != false) {
              Get.offAllNamed("/Advertiser");
            }
          }
        } else {
          /// Reset field
          mobileVerificationCodeController.clear();
        }
      }
    }
  }
}
