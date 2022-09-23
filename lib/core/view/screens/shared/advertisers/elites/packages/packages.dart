import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/advertisers/packages/packages_controller.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/shared/packages/package.dart';

class ElitesPackagesScreen extends StatefulWidget {
  const ElitesPackagesScreen({Key? key}) : super(key: key);

  @override
  _ElitesPackagesScreenState createState() => _ElitesPackagesScreenState();
}

class _ElitesPackagesScreenState extends State<ElitesPackagesScreen> {
  final CarouselController _controller = CarouselController();
  List<Widget> carouselSliderCounterList = [];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Elite Packages'.tr,
      child: GetX(
        init: PackagesController(),
        builder: (PackagesController controller) => Column(
          children: [
            /// Edges
            Container(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
                end: 12,
              ),
              height: 12,
            ),

            /// Loading
            Visibility(
              visible: controller.isLoadingPackages.value == true,
              child: Expanded(
                child: Center(
                  child: LoadingBouncingLine.circle(),
                ),
              ),
            ),

            /// No Packages
            Visibility(
              visible: (!(controller.shownPackages.length > 0 ||
                      controller.userPackage != null) &&
                  controller.isLoadingPackages.value == false),
              child: Expanded(
                child: Center(
                  child: Text('No packages right now.'.tr),
                ),
              ),
            ),

            /// User Package
            Visibility(
              visible: (controller.isLoadingPackages.value == false &&
                  (controller.userPackage != null)),
              child: Expanded(
                child: (controller.userPackage != null
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(
                          bottom: 12,
                        ),
                        child: WPackage(controller.userPackage!),
                      )
                    : SizedBox()),
              ),
            ),

            /// Packages
            (controller.shownPackages.length > 0 &&
                    controller.isLoadingPackages.value == false
                ? Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: CarouselSlider(
                            items: controller.shownPackages.entries
                                .map((entry) => WPackage(entry.value))
                                .toList(),
                            carouselController: _controller,
                            options: CarouselOptions(
                              viewportFraction: 1,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              disableCenter: true,
                              enableInfiniteScroll:
                                  (controller.shownPackages.length > 1),
                              onPageChanged: (index, reason) =>
                                  setState(() => _current = index),
                            ),
                          ),
                        ),

                        /// Dots
                        (controller.shownPackages.length > 1
                            ? SafeArea(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: controller.shownPackages.keys
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map(
                                    (entry) {
                                      return GestureDetector(
                                        onTap: () => _controller
                                            .animateToPage(entry.key),
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withOpacity(
                                              _current == entry.key ? 0.9 : 0.4,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              )
                            : SizedBox(height: 24)),
                      ],
                    ),
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// Delete controllers
    Get.delete<PackagesController>();

    super.dispose();
  }
}
