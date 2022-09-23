import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:m3rady/core/view/theme/colors.dart';

Widget ChatLayout({
  required Widget child,
  required var toUser,
  double elevation = 0,
  bool automaticallyImplyLeading = true,
  bool isDefaultPadding = true,
}) =>
    Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              /// Image
              GestureDetector(
                onTap: () {
                  /// Goto user profile
                  if (!toUser.isSelf) {
                    /// Redirect to advertiser profile
                    if (toUser.type == 'advertiser') {
                      Get.toNamed('/advertiser/profile', arguments: {
                        'id': toUser.id,
                      });
                    } else if (toUser.type == 'customer') {
                      Get.toNamed('/customer/profile', arguments: {
                        'id': toUser.id,
                      });
                    }
                  } else {
                    Get.toNamed('/profile/me');
                  }
                },
                child: WUserImage(
                  toUser.imageUrl,
                  isElite: toUser.isElite,
                  radius: 20,
                ),
              ),

              SizedBox(
                width: 12,
              ),

              /// Name && is connected
              Container(
                width: Get.width - 125,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name
                    GestureDetector(
                      onTap: () {
                        /// Goto user profile
                        if (!toUser.isSelf) {
                          /// Redirect to advertiser profile
                          if (toUser.type == 'advertiser') {
                            Get.toNamed('/advertiser/profile', arguments: {
                              'id': toUser.id,
                            });
                          } else if (toUser.type == 'customer') {
                            Get.toNamed('/customer/profile', arguments: {
                              'id': toUser.id,
                            });
                          }
                        } else {
                          Get.toNamed('/profile/me');
                        }
                      },
                      child: Text(
                        toUser.fullName,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),

                    /// Connection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: (toUser.isOnline == true
                                ? Colors.lightGreen
                                : Colors.grey.shade400),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          (toUser.isOnline == true
                              ? 'Online'.tr
                              : 'Offline'.tr),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            elevation: elevation,
            automaticallyImplyLeading: automaticallyImplyLeading,
            centerTitle: false,
          ),
          body: WillPopScope(
            onWillPop: () async {
              return !GlobalVariables.isMainLoading.value;
            },
            child: GestureDetector(
              onTap: () {
                Get.focusScope?.unfocus();
              },
              child: Container(
                color: ApplicationColors.colors['primary'],
                child: Container(
                  width: Get.size.width,
                  height: Get.size.height,
                  padding: (isDefaultPadding
                      ? EdgeInsetsDirectional.only(
                          start: 12,
                          end: 12,
                        )
                      : null),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),

        /// Loading
        Obx(
          () => Visibility(
            visible: GlobalVariables.isMainLoading.value,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: assets['logoLight'],
                      width: Get.width / 6,
                    ),
                    LoadingBouncingLine.circle(
                      backgroundColor: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
