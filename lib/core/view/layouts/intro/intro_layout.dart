import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/theme/colors.dart';

Widget IntroLayout({
  required Widget child,
  String? title,
  double elevation = 0,
  bool automaticallyImplyLeading = true,
}) =>
    Stack(
      children: [
        Container(
          color: ApplicationColors.colors['primary'],
          child: GestureDetector(
            onTap: () {
              Get.focusScope?.unfocus();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              width: Get.size.width,
              height: Get.size.height,
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
