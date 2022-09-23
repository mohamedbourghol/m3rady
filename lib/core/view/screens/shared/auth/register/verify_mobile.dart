import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/auth/register_controller.dart';
import 'package:m3rady/core/helpers/dio_helper.dart';
import 'package:m3rady/core/view/layouts/auth/auth_layout.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class RegisterVerifyMobileScreen extends StatefulWidget {
  @override
  State<RegisterVerifyMobileScreen> createState() => _RegisterVerifyMobileScreenState();
}

class _RegisterVerifyMobileScreenState extends State<RegisterVerifyMobileScreen> {
  RegisterController registerController
  = Get.find<RegisterController>();
  bool useFirebase=false;
  late Timer _myTimer;
  int sec=20;

  @override
  void initState() {
     run();
    super.initState();
  }



  void run(){
    if(sec==0)
    sec=30;
    else
    _myTimer = Timer.periodic(// assing new timer to our variable.
        Duration(
          seconds: 1,

        ),
            (timer) {
          if(sec==0)
            {
            //  _myTimer.cancel();
            }
          else{
            if(sec>0&&mounted)
            this.setState(() {
              sec--;
            });
          }

    });

  }

  @override
  Widget build(BuildContext context) {

    return AuthLayout(
      automaticallyImplyLeading: false,
      title: 'Validate Mobile Number'.tr,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Body
            Container(
              child: GetBuilder<RegisterController>(
                builder: (_) => Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: registerController.mobileVerifyFormKey,
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
                          'The verification code has been sent to your mobile number'
                              .tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      Text(
                        registerController.mobileFullController.text.toString(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      PinCodeTextField(
                        autofocus: true,
                        controller:
                            registerController.mobileVerificationCodeController,
                        highlight: true,
                        highlightColor: Colors.black.withOpacity(0.1),
                        defaultBorderColor: Colors.black.withOpacity(0.1),
                        hasTextBorderColor: Colors.black.withOpacity(0.1),
                        highlightPinBoxColor: Colors.black.withOpacity(0.1),
                        pinBoxColor: Colors.black.withOpacity(0.1),
                        errorBorderColor: Colors.red.withOpacity(0.5),
                        maxLength: 6,
                        hasError: registerController.isMobileVerifyHasError,
                        onTextChanged: (text) {
                          /// Set is mobile verify has error
                          registerController.setIsMobileVerifyHasError(false);
                        },
                        onDone: (code) async {
                          await DioHelper.init();
                          /// Register user
                          await registerController.register(
                            mobileVerificationCode: code,
                            isRequestMobileVerificationCode: false,
                            go: (){},
                            useFirebase: useFirebase
                          );
                        },
                        pinBoxWidth: 40,
                        pinBoxHeight: 40,
                        wrapAlignment: WrapAlignment.spaceAround,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 22.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 200),
                        highlightAnimation: true,
                        highlightAnimationBeginColor:
                            Colors.black.withOpacity(0.1),
                        highlightAnimationEndColor:
                            Colors.black.withOpacity(0.3),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                      ),

                      SizedBox(
                        height: 6,
                      ),

                      Visibility(
                        child: Center(
                          child: Text(
                            'Invalid verification code'.tr,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        visible: registerController.isMobileVerifyHasError,
                      ),

                      Visibility(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                        visible: registerController.isVerifyingMobile,
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      CBr(),

                      SizedBox(
                        height: 32,
                      ),

                      /// Resend code
                      Text(
                        "Didn't receive the code?".tr,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text(
                              'Resend code'.tr,
                            ),
                            onPressed: sec >
                                    0
                                ? null
                                : () {
                              run();
                              useFirebase=true;
                               registerController
                                   .sendMobileVerificationCode(context);
                            }
                          ),
                          Visibility(
                            child: Text(
                              "(${sec.toString()})",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            visible: (sec >
                                0),
                          )
                        ],
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

class SampleStrategy {}
