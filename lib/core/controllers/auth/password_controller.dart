import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/view/components/components.dart';

/// GetxController disposable interface (remove form stack)
class PasswordController extends GetxController {
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
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

  bool passwordVisibility = false;
  bool passwordConfirmationVisibility = false;
  bool isAgreeToPolicies = false;
  bool isAgreeToSendNotifications = true;
  bool isMobileVerifyHasError = false;
  bool isVerifyingMobile = false;
  bool isResettingPassword = false;
  var verifyingResendCodeTimer;
  int verifyingResendCodeTimerValue = 0;
  int resendMobileVerificationCodeTimes = 0;

  /*
   * Check Mobile Verification Code
   */
  Future checkMobileVerificationCode() async {
    /// Start
    MainLoader.set(true);

    await Authentication.signInPhoneCredentials(
      mobileFullController.text.trim(),
      code: mobileVerificationCodeController.text,
    );

    /// Stop loader
    MainLoader.set(false);

    if (Authentication.firebaseUser != null &&
        Authentication.firebaseUser?.uid != null) {
      /// Set error state
      setIsMobileVerifyHasError(false);

      Get.offAllNamed('/auth/password/reset', arguments: {
        'mobile': mobileFullController.text.trim(),
        'uid': Authentication.firebaseUser?.uid,
      });
    } else {
      /// Set error state
      setIsMobileVerifyHasError(true);
    }
  }

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
 * Send mobile verification code
 */
  Future sendMobileVerificationCode() async {
    /// Reset field
    mobileVerificationCodeController.clear();

    /// Send code
    CConfirmDialog(
      content:
          "You might need to prove that you are not a robot to register! You will be redirected to the validation after confirmation."
              .tr,
      confirmText: 'Confirm'.tr,
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        /// Start loading
        MainLoader.set(true);

        await Authentication.signInPhoneCredentials(
          mobileFullController.text.trim(),
          codeSentCallback: () async {
            /// Start timer
           // startSendMobileVerificationCodeTimer();

            /// Go to mobile verification screen
            if (Get.currentRoute.toString() != '/auth/password/mobile/verify') {
              Get.toNamed('/auth/password/mobile/verify');
            }
          },
          verificationFailedCallback: () {
            /// Show error
            CErrorDialog(errors: ['Verification failed, please try again!'.tr]);

            /// Set mobile has error
            setIsMobileVerifyHasError(true);
          },
        );
      },
    );

    /// Stop loading
    MainLoader.set(false);
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

  /*
 * Validate forgot form
 */
  bool validateForgotForm() {
    FormState? form = forgotPasswordFormKey.currentState;
    if (form != null) {
      return form.validate();
    }
    return false;
  }

  /*
 * Validate reset form
 */
  bool validateResetPasswordForm() {
    FormState? form = resetPasswordFormKey.currentState;
    if (form != null) {
      return form.validate();
    }
    return false;
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
 * Reset the password (API)
 */
  Future resetPassword({
    mobile,
    uid,
    password,
    int? sendResetSms,
    int? smsOtp
  }) async {
    /// Start loading
    MainLoader.set(true);
    String countryCode=mobile.toString().substring(0,3);
    print("countryCode");
    print(countryCode);
    print("countryCode");
    var reset = await User.resetPassword(
      mobile: mobile ?? mobileFullController.text.trim(),
      uid: uid,
      password: password,
      smsOtp: smsOtp,
      sendResetSms: sendResetSms
    );

    ///isResettingPassword = true;
    ///update();

    /// Stop loading
    MainLoader.set(false);

    return reset;
  }
}
