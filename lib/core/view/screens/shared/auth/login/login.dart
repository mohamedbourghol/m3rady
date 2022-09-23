import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/controllers/auth/login_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/auth/login_layout.dart';
import 'package:m3rady/core/view/widgets/inputs/phone_number_input_text.dart';

class LoginScreen extends StatefulWidget {
  /// Set login controller
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Set login controller
  final LoginController loginController = Get.put(LoginController());

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  /// Validate form
  bool validateForm() {
    FormState? form = loginFormKey.currentState;
    if (form != null) {
      return form.validate();
    }
    return false;
  }

  /// Set country code
  var _countryCode = GlobalVariables.userGeoIpCountryCode;

  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      title: 'Login'.tr,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Header
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 12,
                bottom: 12,
              ),
              child: CLogo(
                size: 120,
              ),
            ),

            /// Body
            Container(
              child: Form(
                key: loginFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),

                    Text(
                      'Login using your account'.tr,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(
                      height: 12,
                    ),

                    WInternationalPhoneNumberInputText(
                      controller: loginController.mobileController,
                      fullController: loginController.mobileFullController,
                      onInputChanged: (PhoneNumber number) {
                        _countryCode = number.isoCode.toString();
                      },
                      initalValue: PhoneNumber(
                        isoCode: _countryCode,
                      ),
                      isRequired: true,
                    ),

                    SizedBox(
                      height: 12,
                    ),

                    CTextFormField(
                      controller: loginController.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isPasswordHidden,
                      textDirection: TextDirection.ltr,
                      labelText: 'Password'.tr,
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onTap: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                      isRequired: true,
                      onEditingComplete: () {
                        Get.focusScope?.nextFocus();
                      },
                    ),

                    Container(
                      alignment: AlignmentDirectional.topEnd,
                      child: TextButton(
                        child: Text('Forgot password?'.tr),
                        onPressed: () {
                          Get.toNamed('/auth/password/forgot');
                        },
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    CMaterialButton(
                      child: Text(
                        'Login'.tr,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        /// Unfocus
                        Get.focusScope?.unfocus();

                        /// Login
                        if (validateForm()) {
                          loginController.loginAccount();
                        }
                      },
                    ),

                    SizedBox(
                      height: 5,
                    ),


                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "Don't have account?".tr,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          InkWell(
                            child: Text(
                              'Register Now'.tr,
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              /// Unfocus
                              Get.focusScope?.unfocus();

                              Get.toNamed('/auth/account-type');
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    CBr(),

                    /// Social  login
                    Visibility(
                      visible: config['isActivateSocialLogin'],
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16,
                          ),

                          Text(
                            'Or login using'.tr,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),

                          /// Social login
                          SizedBox(
                            height: 12,
                          ),



                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),

                    /// Guest login
                    TextButton(
                      child: Text(
                        'Login as guest'.tr,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () async {
                        /// Unfocus
                        Get.focusScope?.unfocus();

                        CConfirmDialog(
                          content:
                              "When you log in as a guest that means you read and accept the Terms of conditions and the Privacy policy.  As a guest, you can't create or interact with the posts or the users. We advise you to register an account to create and comment on posts and to get all the features of the application."
                                  .tr,
                          confirmText: 'Login as guest'.tr,
                          confirmTextColor: Colors.orange,
                          confirmCallback: () async {
                            /// Start loading
                            MainLoader.set(true);

                            /// Login guest
                            await loginController.loginGuest();

                            /// Stop loading
                            MainLoader.set(false);
                          },
                        );
                      },
                    ),


                    SizedBox(
                      height: 6,
                    ),

                    /// Policies
                    InkWell(
                      child: Text(
                        " ${'Terms and Conditions'.tr} ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed('/page',
                            arguments: {'page': 'Terms and Conditions'});
                      },
                    ),

                    SizedBox(
                      height: 6,
                    ),

                    InkWell(
                      child: Text(
                        " ${'Privacy Policy'.tr} ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed('/page',
                            arguments: {'page': 'Privacy Policy'});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
