import 'package:flutter/material.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/components/components.dart';

class EditContactScreen extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController(
    loadCategories: false,
    loadCountries: false,
    loadSocialLogin: true,
  ));

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Edit Social Accounts'.tr,
      child: GetBuilder<AccountController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              /// User data
              Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: controller.updateSocialAccountsFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12,
                        ),
                        child: Text(
                          'Contact Number'.tr,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CTextFormField(
                          controller: controller.contactMobileController,
                          keyboardType: TextInputType.phone,
                          hintText: "+966123456789",
                          onEditingComplete: () {
                            Get.focusScope?.nextFocus();
                          },
                          validator: (value) {
                            if (value.length > 0 &&
                                (!(new RegExp(r'^[+][0-9]+$'))
                                        .hasMatch(value) ||
                                    !value.toString().isPhoneNumber)) {
                              return 'The mobile number is invalid.'.tr;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      /// Title
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12,
                        ),
                        child: Text(
                          'Whatsapp Number'.tr,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CTextFormField(
                          controller: controller.whatsappMobileController,
                          keyboardType: TextInputType.phone,
                          hintText: "+966123456789",
                          onEditingComplete: () {
                            Get.focusScope?.nextFocus();
                          },
                          validator: (value) {
                            if (value.length > 0 &&
                                (!(new RegExp(r'^[+][0-9]+$'))
                                        .hasMatch(value) ||
                                    !value.toString().isPhoneNumber)) {
                              return 'The mobile number is invalid.'.tr;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      /// Title
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12,
                        ),
                        child: Text(
                          'Facebook Url'.tr,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CTextFormField(
                          controller: controller.facebookLinkController,
                          keyboardType: TextInputType.url,
                          hintText: "https://www.facebook.com/username",
                          onEditingComplete: () {
                            Get.focusScope?.nextFocus();
                          },
                          validator: (value) {
                            if (value.length > 0 && !value.toString().isURL) {
                              return 'The url is invalid.'.tr;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      /// Title
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12,
                        ),
                        child: Text(
                          'Twitter Url'.tr,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CTextFormField(
                          controller: controller.twitterLinkController,
                          keyboardType: TextInputType.url,
                          textDirection: TextDirection.ltr,
                          hintText: "https://www.twitter.com/username",
                          onEditingComplete: () {
                            Get.focusScope?.nextFocus();
                          },
                          validator: (value) {
                            if (value.length > 0 && !value.toString().isURL) {
                              return 'The url is invalid.'.tr;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),

                      /// Title
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12,
                        ),
                        child: Text(
                          'Website Url'.tr,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CTextFormField(
                          controller: controller.websiteLinkController,
                          keyboardType: TextInputType.url,
                          textDirection: TextDirection.ltr,
                          hintText: "https://www.m3radyapp.com",
                          onEditingComplete: () {
                            Get.focusScope?.nextFocus();
                          },
                          validator: (value) {
                            if (value.length > 0 && !value.toString().isURL) {
                              return 'The url is invalid.'.tr;
                            }
                          },
                        ),
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
                          if (controller
                              .updateSocialAccountsFormKey.currentState!
                              .validate()) {
                            await controller.updateAccount(
                              contactNumber: controller
                                  .contactMobileController.text
                                  .trim(),
                              whatsappNumber: controller
                                  .whatsappMobileController.text
                                  .trim(),
                              facebookUrl:
                                  controller.facebookLinkController.text.trim(),
                              twitterUrl:
                                  controller.twitterLinkController.text.trim(),
                              websiteUrl:
                                  controller.websiteLinkController.text.trim(),
                            );
                          }
                        },
                      ),

                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),

              /// Break
              Container(
                color: Colors.grey.shade200,
                height: 6,
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Location:'.tr,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(
                      height: 6,
                    ),

                    Text(
                      'Add your geographic location to make it easier for your customers to reach you.'
                          .tr,
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    /// Buttons
                    Row(
                      children: [
                        Visibility(
                          visible: (controller.user.addressLatitude != null &&
                              controller.user.addressLongitude != null),
                          child: TextButton(
                            onPressed: () async {
                              Get.toNamed('/account/location/edit');
                            },
                            child: Text(
                              'Edit'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.only(
                                left: 6,
                                right: 6,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (controller.user.addressLatitude != null &&
                              controller.user.addressLongitude != null),
                          child: SizedBox(
                            width: 12,
                          ),
                        ),
                        Visibility(
                          visible: (controller.user.addressLatitude != null &&
                              controller.user.addressLongitude != null),
                          child: TextButton(
                            onPressed: () async {
                              CConfirmDialog(
                                confirmText: 'Delete'.tr,
                                confirmCallback: () async {
                                  await controller.updateAccount(
                                    addressLongitude: '',
                                    addressLatitude: '',
                                    showRequestErrors: false,
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Delete'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.only(
                                left: 6,
                                right: 6,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !(controller.user.addressLatitude != null &&
                              controller.user.addressLongitude != null),
                          child: TextButton(
                            onPressed: () async {
                              Get.toNamed('/account/location/edit');
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Add Location'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsetsDirectional.only(
                                start: 12,
                                end: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Break
              Container(
                color: Colors.grey.shade200,
                height: 6,
              ),

              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
