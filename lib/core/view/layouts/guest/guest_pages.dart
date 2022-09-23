import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/system/languages/languages_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/elites/elites.dart';
import 'package:m3rady/core/view/screens/shared/home/home.dart';
import 'package:share/share.dart';


class Guest extends StatefulWidget {
  const Guest({Key? key}) : super(key: key);

  @override
  _GuestState createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  PageController pageController=PageController(
      initialPage: 0
  );
  List<String> titles=['Home'.tr,'Elite Packages'.tr,'More'.tr];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LanguageController appLanguage = Get.find<LanguageController>();

  bool automaticallyImplyLeading = true;
  int bottomNavigationBarIndex = 0;





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !GlobalVariables.isMainLoading.value;
      },
      child: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            titleSpacing: 12,
            title: Text(
              titles[bottomNavigationBarIndex],
              style: Get.theme.appBarTheme.titleTextStyle,
            ),
            actions: [
              /// Set search pages
              [0, 2].contains(bottomNavigationBarIndex)
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    Get.toNamed('/search');
                  },
                ),
              )
                  : SizedBox(),
            ],
            elevation: 0,
            automaticallyImplyLeading: automaticallyImplyLeading,
          ),
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    HomeScreen(),

                    ElitesAdvertisersScreen(),

                    Container(
                      width: Get.width / 1.2,
                      child: Drawer(
                        child: SafeArea(
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                title: Text('Elite Advertisers'.tr),
                                leading: Image(
                                  image: assets['eliteOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  /// Set index to elites tap
                                  bottomNavigationBarIndex = 1;

                                  pageController.jumpToPage(bottomNavigationBarIndex);
                                  setState(() {

                                  });
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('The Offers'.tr),
                                leading: Image(
                                  image: assets['adsOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/offers');
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Change language'.tr),
                                leading: Image(
                                  image: assets['langOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'Change language'.tr,
                                    middleText: '',
                                    backgroundColor: Colors.white,
                                    titleStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    middleTextStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    cancelTextColor: Colors.black38,
                                    buttonColor: Colors.white,
                                    textCancel: "Cancel".tr,
                                    barrierDismissible: false,
                                    radius: 25,
                                    content: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Choose your favorite language'.tr,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'The application will be restarted after changing the language.'
                                              .tr,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        CBr(),
                                        ListTile(
                                          title: Center(child: Text('Arabic'.tr)),
                                          onTap: () {
                                            if (appLanguage.userLocale != 'ar') {
                                              /// Set index to main
                                              bottomNavigationBarIndex = 0;

                                              appLanguage.updateLocale('ar');
                                            }

                                            Get.back();
                                          },
                                        ),
                                        CBr(),
                                        ListTile(
                                          title: Center(child: Text('English'.tr)),
                                          onTap: () {
                                            if (appLanguage.userLocale != 'en') {
                                              /// Set index to main
                                              bottomNavigationBarIndex = 0;

                                              appLanguage.updateLocale('en');
                                            }

                                            Get.back();
                                          },
                                        ),
                                        CBr(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Share the app'.tr),
                                leading: Image(
                                  image: assets['shareOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Share.share(config['shareAppText']);
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('In-app advertising'.tr),
                                leading: Image(
                                  image: assets['tableOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/contact-us',
                                      arguments: {'type': 'In-app advertising'});
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Contact Us'.tr),
                                leading: Image(
                                  image: assets['emailOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/contact-us');
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Terms and Conditions'.tr),
                                leading: Image(
                                  image: assets['fileOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/page',
                                      arguments: {'page': 'Terms and Conditions'});
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('About Us'.tr),
                                leading: Image(
                                  image: assets['askOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/page', arguments: {'page': 'About Us'});
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Registration'.tr),
                                leading: Image(
                                  image: assets['logoutOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  /// Set index to main
                                  bottomNavigationBarIndex = 0;

                                  /// Go to login
                                  Get.offAllNamed('/auth/login');
                                },
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "${'Version'.tr} ${config['version']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                  ],),
              ),
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
          ),
          bottomNavigationBar: BottomNavigationBar(
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            iconSize: 30,
            onTap: (int index) {
              /// Handle More Tap
            if (index != bottomNavigationBarIndex) {
                /// Set index
                bottomNavigationBarIndex = index;
                pageController.jumpToPage(bottomNavigationBarIndex);
                setState(() {

                });


              }
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'.tr,
                tooltip: 'Home'.tr,
              ),

              BottomNavigationBarItem(
                icon: Image(
                  image: assets['elites'],
                  width: 30,
                  height: 30,
                ),
                label: 'Elite'.tr,
                tooltip: 'Elite'.tr,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz_outlined),
                label: 'More'.tr,
                tooltip: 'More'.tr,
              ),
            ],
          ),
          drawer: Container(
            width: Get.width / 1.2,
            child: Drawer(
              child: SafeArea(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Elite Advertisers'.tr),
                      leading: Image(
                        image: assets['eliteOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        /// Set index to elites tap
                        bottomNavigationBarIndex = 1;
                        pageController.jumpToPage(bottomNavigationBarIndex);
                        scaffoldKey.currentState!.openEndDrawer();
                        setState(() {
                        });
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('The Offers'.tr),
                      leading: Image(
                        image: assets['adsOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/offers');
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Change language'.tr),
                      leading: Image(
                        image: assets['langOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Change language'.tr,
                          middleText: '',
                          backgroundColor: Colors.white,
                          titleStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          middleTextStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          cancelTextColor: Colors.black38,
                          buttonColor: Colors.white,
                          textCancel: "Cancel".tr,
                          barrierDismissible: false,
                          radius: 25,
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Choose your favorite language'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'The application will be restarted after changing the language.'
                                    .tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CBr(),
                              ListTile(
                                title: Center(child: Text('Arabic'.tr)),
                                onTap: () {
                                  if (appLanguage.userLocale != 'ar') {
                                    /// Set index to main
                                    bottomNavigationBarIndex = 0;

                                    appLanguage.updateLocale('ar');
                                  }

                                  Get.back();
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Center(child: Text('English'.tr)),
                                onTap: () {
                                  if (appLanguage.userLocale != 'en') {
                                    /// Set index to main
                                    bottomNavigationBarIndex = 0;

                                    appLanguage.updateLocale('en');
                                  }

                                  Get.back();
                                },
                              ),
                              CBr(),
                            ],
                          ),
                        );
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Share the app'.tr),
                      leading: Image(
                        image: assets['shareOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Share.share(config['shareAppText']);
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('In-app advertising'.tr),
                      leading: Image(
                        image: assets['tableOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/contact-us',
                            arguments: {'type': 'In-app advertising'});
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Contact Us'.tr),
                      leading: Image(
                        image: assets['emailOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/contact-us');
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Terms and Conditions'.tr),
                      leading: Image(
                        image: assets['fileOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/page',
                            arguments: {'page': 'Terms and Conditions'});
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('About Us'.tr),
                      leading: Image(
                        image: assets['askOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/page', arguments: {'page': 'About Us'});
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Registration'.tr),
                      leading: Image(
                        image: assets['logoutOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        /// Set index to main
                        bottomNavigationBarIndex = 0;

                        /// Go to login
                        Get.offAllNamed('/auth/login');
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "${'Version'.tr} ${config['version']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
