import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/theme/colors.dart';

Widget MainLayout({
  required Widget child,
  String? title,
  double elevation = 0,
  bool automaticallyImplyLeading = true,
  bool isDefaultPadding = true,
  Color backgroundColor = Colors.white,
  Widget? floatingActionButton,
  List<Widget>? actions,
}) =>
    Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 12,
            title: Text(
              title ?? config['appName'].toString().tr,
              style: Get.theme.appBarTheme.titleTextStyle,
            ),
            elevation: elevation,
            automaticallyImplyLeading: automaticallyImplyLeading,
            actions: actions ?? [],
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
                    color: backgroundColor,
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
          floatingActionButton: floatingActionButton,
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
