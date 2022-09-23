import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final AccountController accountController = Get.put(AccountController());
  TextEditingController passwordController = TextEditingController();
  void showEditMobileDialog() {}

  void showEditPrivacyDialog() {
    /// Set current data
    accountController.selectedProfilePrivacy = accountController
        .user.profilePrivacy
        .toString()
        .replaceAll('ProfilePrivacy.', '');

    CConfirmDialog(
      confirmText: 'Save'.tr,
      title: 'Edit Privacy'.tr,
      contentWidget: Column(
        children: [
          Text(
            'Prevent others from viewing your profile'.tr,
          ),
          SizedBox(
            height: 12,
          ),
          Form(
            key: accountController.accountPrivacyFormKey,
            child: CSelectFormField(
              value: accountController.selectedProfilePrivacy,
              isRequired: true,
              labelText: 'Edit Privacy'.tr,
              items: [
                DropdownMenuItem<String>(
                  value: 'public',
                  child: Text(
                    'All Users'.tr,
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'followers',
                  child: Text(
                    'Followers'.tr,
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'private',
                  child: Text(
                    'Only me'.tr,
                  ),
                ),
              ],
              onChanged: (value) =>
                  accountController.changeSelectedProfilePrivacy(value),
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        if (accountController.accountPrivacyFormKey.currentState!.validate()) {
          /// Back
          Get.back();

          /// Send request
          await accountController.updateAccount(
            profilePrivacy: accountController.selectedProfilePrivacy,
          );
        }
      },
      autoClose: false,
    );
  }

  void showEditMessagingDialog() {
    /// Set current data
    accountController.selectedChatPrivacy = accountController.user.chatStatus
        .toString()
        .replaceAll('ChatStatus.', '');

    CConfirmDialog(
      confirmText: 'Save'.tr,
      title: 'Disable Messages'.tr,
      contentWidget: Column(
        children: [
          Text(
            'You can prevent messages from being sent to you'.tr,
          ),
          SizedBox(
            height: 12,
          ),
          Form(
            key: accountController.chatPrivacyFormKey,
            child: CSelectFormField(
              value: accountController.selectedChatPrivacy,
              isRequired: true,
              labelText: 'Disable Messages'.tr,
              items: [
                DropdownMenuItem<String>(
                  value: 'public',
                  child: Text(
                    'All Users'.tr,
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'followers',
                  child: Text(
                    'Followers'.tr,
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'disabled',
                  child: Text(
                    'Disabled'.tr,
                  ),
                ),
              ],
              onChanged: (value) =>
                  accountController.changeSelectedChatPrivacy(value),
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        if (accountController.chatPrivacyFormKey.currentState!.validate()) {
          /// Back
          Get.back();

          /// Send request
          await accountController.updateAccount(
            chatStatus: accountController.selectedChatPrivacy,
          );
        }
      },
      autoClose: false,
    );
  }

  void showDisableAccountDialog() {
    /// Set current data
    accountController.selectedAccountStatus = accountController
        .user.accountStatus
        .toString()
        .replaceAll('UserStatus.', '');

    CConfirmDialog(
      confirmText: 'Save'.tr,
      title: 'Disable Account'.tr,
      contentWidget: Column(
        children: [
          Text(
            'Disable your account and hide your profile'.tr,
          ),
          SizedBox(
            height: 12,
          ),
          Form(
            key: accountController.disableAccountFormKey,
            child: CSelectFormField(
              value: accountController.selectedAccountStatus,
              isRequired: true,
              labelText: 'Account Status'.tr,
              items: [
                DropdownMenuItem<String>(
                  value: 'active',
                  child: Text(
                    'Active'.tr,
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'inactive',
                  child: Text(
                    'Disabled'.tr,
                  ),
                ),
              ],
              onChanged: (value) =>
                  accountController.changeSelectedAccountStatus(value),
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        if (accountController.disableAccountFormKey.currentState!.validate()) {
          /// Back
          Get.back();

          /// Send request
          await accountController.updateAccount(
            isDisableAccount:
                accountController.selectedAccountStatus == 'inactive',
          );
        }
      },
      autoClose: false,
    );
  }

  void showDeleteAccountDialog() {
    /// Set current data
    accountController.selectedAccountStatus = accountController
        .user.accountStatus
        .toString()
        .replaceAll('UserStatus.', '');

    CConfirmDialog(
      confirmText: 'Delete Account'.tr,
      title: 'Delete Account'.tr,

      contentWidget: Column(
        children: [
          Text(
            'Delete your account and hide your profile'.tr,
          ),
          SizedBox(
            height: 12,
          ),
          Form(

            child: CTextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textDirection: TextDirection.ltr,
              labelText: 'Password'.tr,
              prefixIcon: Icon(
                Icons.lock,
              ),
              isRequired: true,
              onEditingComplete: () {
                Get.focusScope?.nextFocus();
              },
            ),
          ),

        ],
      ),
      confirmTextColor: Colors.red,
      confirmCallback: () async {

          /// Back
          Get.back();

          /// Send request
          await accountController.deleteAccount(
            password: passwordController.text
          );

      },
      autoClose: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'My Account'.tr,
      child: Obx(
        () => accountController.isLoadingProfile.value == true
            ? Center(
                child: LoadingBouncingLine.circle(),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0.5,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0.5,
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: ListTile(
                              title: Text('Edit Profile'.tr),
                              leading: Image(
                                image: assets['profileDark'],
                              ),
                              minLeadingWidth: 0,
                              onTap: () {
                                Get.toNamed('/account/profile/edit');
                              },
                            ),
                          ),

                          /// Break
                          GlobalVariables.user.type == 'customer'
                              ? SizedBox()
                              : SizedBox(
                                  height: 6,
                                ),

                          GlobalVariables.user.type == 'customer'
                              ? SizedBox()
                              : Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Text('Edit Social Accounts'.tr),
                                    leading: Image(
                                      image: assets['contactDark'],
                                    ),
                                    minLeadingWidth: 0,
                                    onTap: () {
                                      Get.toNamed('/account/contact/edit');
                                    },
                                  ),
                                ),

                          /// Break
                          SizedBox(
                            height: 6,
                          ),

                          /// Social  login
                          Visibility(
                            visible: config['isActivateSocialLogin'],
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Text('Social login'.tr),
                                    leading: Image(
                                      image: assets['socialDark'],
                                    ),
                                    minLeadingWidth: 0,
                                    onTap: () {
                                      Get.toNamed('/account/social/login/edit');
                                    },
                                  ),
                                ),

                                /// Break
                                SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),



                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text('Edit Password'.tr),
                              leading: Image(
                                image: assets['passwordDark'],
                              ),
                              minLeadingWidth: 0,
                              onTap: () {
                                Get.toNamed('/account/password/edit');
                              },
                            ),
                          ),

                          /// Break
                          SizedBox(
                            height: 6,
                          ),

                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text('Edit Privacy'.tr),
                              leading: Image(
                                image: assets['keyDark'],
                              ),
                              minLeadingWidth: 0,
                              onTap: () => showEditPrivacyDialog(),
                            ),
                          ),

                          /// Break
                          SizedBox(
                            height: 6,
                          ),

                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text('Blocked Users'.tr),
                              leading: Image(
                                image: assets['blockDark'],
                              ),
                              minLeadingWidth: 0,
                              onTap: () {
                                Get.toNamed('/account/block/users');
                              },
                            ),
                          ),

                          /// Break
                          SizedBox(
                            height: 6,
                          ),

                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text('Disable Messages'.tr),
                              leading: Image(
                                image: assets['chatDark'],
                              ),
                              minLeadingWidth: 0,
                              onTap: () => showEditMessagingDialog(),
                            ),
                          ),

                          /// Break
                          SizedBox(
                            height: 6,
                          ),

                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text('Disable Account'.tr),
                              leading: Image(
                                image: assets['cancelDark'],
                              ),
                              minLeadingWidth: 0,
                              onTap: () => showDisableAccountDialog(),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),

                          Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text('Delete Account'.tr,
                              style: TextStyle(
                                color: Colors.red
                              ),
                              ),
                              leading: Image(
                                image: assets['cancelDark'],

                              ),
                              minLeadingWidth: 0,
                              onTap: () => showDeleteAccountDialog(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// Delete controllers
    /*if (Get.previousRoute != '' && Get.previousRoute != Get.currentRoute) {
      Get.delete<AccountController>();
    }*/
  }
}
