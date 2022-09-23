import 'package:flutter/material.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'dart:io';

class EditSocialLoginScreen extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController(
    loadCategories: false,
    loadCountries: false,
    loadSocialLogin: true,
  ));

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Social login'.tr,
      child: GetBuilder<AccountController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Connect social media accounts to log in with it'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
              /// Break
              Container(
                color: Colors.grey.shade200,
                height: 6,
              ),

              /// Apple
              !Platform.isIOS
                  ? SizedBox()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              CCircleButton(
                                child: Image(
                                  width: 18,
                                  height: 18,
                                  image: assets['appleLight'],
                                ),
                                color: Colors.black,
                                spalshColor: Colors.white,
                                onPressed: () {},
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              controller.userSocialLoginAccounts?['apple'] ==
                                      null
                                  ? GestureDetector(
                                      onTap: () async {
                                        {
                                          /// Start loading
                                          GlobalVariables.isMainLoading.value =
                                              true;

                                          /// Sign in
                                          await Authentication.getSocialData(
                                            provider: SocialProvider.apple,
                                          ).then((socialAccount) {
                                            /// Add
                                            if (socialAccount != false) {
                                              controller.addUserSocialLogin(
                                                provider:
                                                    socialAccount.provider,
                                                providerId:
                                                    socialAccount.providerId,
                                              );
                                            }
                                          }).catchError((_) {});

                                          /// Stop loading
                                          GlobalVariables.isMainLoading.value =
                                              false;
                                        }
                                      },
                                      child: Text(
                                        'Connect Account'.tr,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        {
                                          CConfirmDialog(
                                              confirmCallback: () async {
                                            /// Start loading
                                            GlobalVariables
                                                .isMainLoading.value = true;

                                            /// delete
                                            controller.deleteUserSocialLogin(
                                              provider: 'apple',
                                            );

                                            /// Stop loading
                                            GlobalVariables
                                                .isMainLoading.value = false;
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Disconnect'.tr,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        /// Break
                        Container(
                          color: Colors.grey.shade200,
                          height: 6,
                        ),
                      ],
                    ),

              /// Google
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    CCircleButton(
                      child: Image(
                        width: 18,
                        height: 18,
                        image: assets['googleColored'],
                      ),
                      color: Colors.white,
                      spalshColor: Colors.white,
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    controller.userSocialLoginAccounts?['google'] == null
                        ? GestureDetector(
                            onTap: () async {
                              {
                                /// Start loading
                                MainLoader.set(true);

                                /// Sign in
                                await Authentication.getSocialData(
                                  provider: SocialProvider.google,
                                ).then((socialAccount) {
                                  /// Add
                                  if (socialAccount != false) {
                                    controller.addUserSocialLogin(
                                      provider: socialAccount.provider,
                                      providerId: socialAccount.providerId,
                                    );
                                  }
                                }).catchError((_) {});

                                /// Stop loading
                                MainLoader.set(false);
                              }
                            },
                            child: Text(
                              'Connect Account'.tr,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              {
                                CConfirmDialog(confirmCallback: () async {
                                  /// Start loading
                                  MainLoader.set(true);

                                  /// delete
                                  controller.deleteUserSocialLogin(
                                    provider: 'google',
                                  );

                                  /// Stop loading
                                  MainLoader.set(false);
                                });
                              }
                            },
                            child: Text(
                              'Disconnect'.tr,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              /// Break
              Container(
                color: Colors.grey.shade200,
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
