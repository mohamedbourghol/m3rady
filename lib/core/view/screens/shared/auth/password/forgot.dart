import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/auth/password_controller.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/auth/auth_layout.dart';
import 'package:m3rady/core/view/widgets/inputs/phone_number_input_text.dart';

class ForgotPasswordScreen extends StatelessWidget {
  /// Set country code
  var _countryCode = GlobalVariables.userGeoIpCountryCode;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Reset Password'.tr,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Body
            Container(
              child: GetBuilder<PasswordController>(
                init: PasswordController(),
                builder: (controller) => Form(
                  key: controller.forgotPasswordFormKey,
                  child: Column(
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
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Please enter the mobile number to reset your password'
                              .tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      WInternationalPhoneNumberInputText(
                        controller: controller.mobileController,
                        fullController: controller.mobileFullController,
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

                      CMaterialButton(
                        child: Text(
                          'Continue'.tr,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (controller.validateForgotForm()) {
                            if(_countryCode=='SA')
                              {
                                print(controller.mobileController.text);
                                /// check mobile
                                var check = await controller.resetPassword(
                                 sendResetSms: 1

                                );

                                if (check != false) {
                                  Get.toNamed('/auth/password/mobile/verify');
                                }

                              }
                            else{

                              /// check mobile
                              var check = await controller.resetPassword();

                              /// send code
                              if (check != false) {
                                await controller.sendMobileVerificationCode();
                              }
                            }



                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
