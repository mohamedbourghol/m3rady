import 'package:flutter/material.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/components/components.dart';

class EditPasswordScreen extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController(
    loadCategories: false,
    loadCountries: false,
    loadSocialLogin: false,
  ));

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Edit Password'.tr,
      child: GetBuilder<AccountController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              /// User data
              Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.updatePasswordFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CTextFormField(
                        controller: controller.oldPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.oldPasswordVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'Old Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            !controller.oldPasswordVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () => controller.toggleOldPasswordVisibility(),
                        ),
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CTextFormField(
                        controller: controller.newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.passwordVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'New Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            !controller.passwordVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () => controller.togglePasswordVisibility(),
                        ),
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CTextFormField(
                        controller:
                            controller.newPasswordConfirmationController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.passwordConfirmationVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'Confirm New Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            !controller.passwordConfirmationVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () =>
                              controller.togglePasswordConfirmationVisibility(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              (value != null && value.isEmpty)) {
                            return 'This field is required'.tr;
                          } else if (controller.newPasswordController.text
                                  .toString() !=
                              controller.newPasswordConfirmationController.text
                                  .toString()) {
                            return 'The password and the password confirmation is not the same'
                                .tr;
                          }
                        },
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CMaterialButton(
                        child: Text(
                          'Save'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          /// Unfocus
                          Get.focusScope?.unfocus();

                          /// Save
                          if (controller.updatePasswordFormKey.currentState!
                              .validate()) {
                            await controller.updateAccount(
                              oldPassword:
                                  controller.oldPasswordController.text,
                              password: controller.newPasswordController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
