import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<bool> onWillPop() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Close the App'.tr,
      desc: 'Do you want to exit the app'.tr,
      btnOkText: 'cancel'.tr,
      btnCancelText: 'confirm'.tr,
      btnCancelOnPress: () {
        exit(0);
      },
      btnOkOnPress: () {},
      btnOkColor: Colors.blue,
    )..show();

    return Future.value(true);
  }


  @override
  void initState() {
    super.initState();

    /// Hide keyboard
    /// FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    /// Set splash timer in seconds
    int splashScreenTimer = 0;

    /// Set next page route
    String nextPageRoute = '/intro';

    /// Delay navigate to a next page
    Future.delayed(
      Duration(seconds: splashScreenTimer),
      () async {
        /// Get local form storage if exists
        bool isShowIntroScreen = (await LocalStorage.check('isShowIntroScreen')
            ? await LocalStorage.get('isShowIntroScreen') == true
            : true);

        /// Check if a user is login
        var user = await Authentication.check(
          unAuthenticateUserIfFaild: true,
          setUserData: true,
        );

        /// If authenticated
        if (user != false) {
          nextPageRoute = '/guest';
          if (GlobalVariables.isUserAuthenticated.value == true) {
            if (GlobalVariables.user.type == 'customer') {
              nextPageRoute = '/customer';
            } else if (GlobalVariables.user.type == 'advertiser') {
              nextPageRoute = '/Advertiser';
            }
          }

        }
        else if (!isShowIntroScreen) {
          /// Set next screen
          nextPageRoute = '/auth/login';
        }

        /// Go next screen
        if (Get.currentRoute != nextPageRoute) {
          Get.offAllNamed(nextPageRoute);
        }
      },
    );
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
    /// Splash screen
    return WillPopScope(
        onWillPop:onWillPop,
        child: GestureDetector(
        onTap: () {
      Get.focusScope?.unfocus();
    },
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: Center(
          child: Container(
            width: Get.size.width,
            height: Get.size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: assets['trailsBuildings'],
                fit: BoxFit.cover,

              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: assets['logoLight'],
                  width: Get.width / 3.5,
                  color: Colors.white.withOpacity(0.9),
                ),
                LoadingBouncingLine.circle(
                  backgroundColor: Colors.white54,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
