import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

import 'auth_controller.dart';

/// GetxController disposable interface (remove form stack)
class LoginController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController mobileFullController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Validate form
  /*bool validateForm() {
    FormState? form = loginFormKey.currentState;
    if (form != null) {
      return form.validate();
    }
    return false;
  }*/

  /// Login account
  Future loginAccount() async {
    //if (validateForm()) {
    await Authentication.loginAccount(
      login: mobileFullController.text,
      password: passwordController.text,
    ).then((user) async {
      if (user != false) {
        await handleUserLogin(user);
      }
    });
    //}
  }

  /// Login account
  Future loginSocial(SocialProvider provider) async {
    await Authentication.loginSocial(
      provider: provider,
    ).then((user) async {
      if (user != false) {
        await handleUserLogin(user);
      }
    });
  }

  /// Login guest
  Future loginGuest() async {

   String nextPageRoute = '/guest';
    if (GlobalVariables.isUserAuthenticated.value == true) {
      if (GlobalVariables.user.type == 'customer') {
        nextPageRoute = '/customer';
      } else if (GlobalVariables.user.type == 'advertiser') {
        nextPageRoute = '/Advertiser';
      }
    }
    Get.offAllNamed(nextPageRoute);
  }

  /// Handle user login
  Future handleUserLogin(User user) async {
    /// Set next screen
    String nextPageRoute = '/guest';
    if (GlobalVariables.isUserAuthenticated.value == true) {
      if (GlobalVariables.user.type == 'customer') {
        nextPageRoute = '/customer';
      } else if (GlobalVariables.user.type == 'advertiser') {
        nextPageRoute = '/Advertiser';
      }
    }

    Get.offAllNamed(nextPageRoute);
  }
}
