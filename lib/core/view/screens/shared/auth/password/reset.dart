import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/auth/password_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/auth/auth_layout.dart';

class ResetPasswordScreen extends StatelessWidget {
  /// Set data
  final mobile = Get.arguments['mobile'];
  final uid = Get.arguments['uid'];

  @override
  Widget build(BuildContext context) {
    PasswordController controller = Get.find<PasswordController>();

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
                builder: (_) => Form(
                  key: controller.resetPasswordFormKey,
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
                          'Please enter the new password'.tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      CTextFormField(
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.passwordVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'New Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            controller.passwordVisibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onTap: () => controller.togglePasswordVisibility(),
                        ),
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                        validator: (value) {
                          if (value == null ||
                              (value != null && value.isEmpty)) {
                            return 'This field is required'.tr;
                          } else if (controller.passwordController.text
                                  .toString() !=
                              controller.passwordConfirmationController.text
                                  .toString()) {
                            return 'The password and the password confirmation is not the same'
                                .tr;
                          }
                        },
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      CTextFormField(
                        controller: controller.passwordConfirmationController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.passwordConfirmationVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'Confirm Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            controller.passwordConfirmationVisibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onTap: () =>
                              controller.togglePasswordConfirmationVisibility(),
                        ),
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      Visibility(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        visible: controller.isResettingPassword,
                      ),

                      CMaterialButton(
                        child: Text(
                          'Confirm'.tr,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        disabled: controller.isResettingPassword,
                        onPressed: () async {
                          if (controller.validateResetPasswordForm()) {
                            var reset = await controller.resetPassword(
                              mobile: mobile,
                              uid: uid,
                              password:
                                  controller.passwordController.text.trim(),
                            );

                            if (reset != false) {
                              /// Success
                              CToast(text: reset['message']);

                              /// Go login
                              Get.offAllNamed('/auth/login');
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
