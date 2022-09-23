import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/controllers/system/languages/languages_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/helpers/notifications_helper.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/elites/elites.dart';
import 'package:m3rady/core/view/screens/shared/home/home.dart';
import 'package:m3rady/core/view/screens/shared/notifications/notifications.dart';
import 'package:m3rady/core/view/screens/shared/profile/new_my_poofile/my_profile_new.dart';
import 'package:share/share.dart';


class Advertiser extends StatefulWidget {
  int intPage;
   Advertiser({Key? key,required this.intPage}) : super(key: key);

  @override
  _AdvertiserState createState() => _AdvertiserState();
}

class _AdvertiserState extends State<Advertiser> {
  late PageController pageController;
  List<String> titles=['Home'.tr,'My Profile'.tr,'Elite Packages'.tr,'Notifications'.tr,'More'.tr];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final InAppReview inAppReview = InAppReview.instance;
  final LanguageController appLanguage = Get.find<LanguageController>();

  late Stream<DocumentSnapshot> notificationsStream;
  bool automaticallyImplyLeading = true;
      int bottomNavigationBarIndex = 0;
  Future<bool> onWillPop() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Close the App'.tr,
      desc: 'Do you want to exit the app'.tr,
      btnOkText: 'cancel'.tr,
      btnCancelText: 'confirm'.tr,
      btnCancelOnPress: () {
        exit(0);
      },
      btnOkOnPress: () {},
      btnOkColor: Colors.blue,
    )..show();

    return Future.value(true);
  }


  @override
  void initState() {

    pageController=PageController(
        initialPage: widget.intPage
    );
    NotificationsHelper.requestNotificationsPermission();
     notificationsStream = FirebaseFirestore.instance
        .collection('notifications')
        .doc("${GlobalVariables.user.type}.${GlobalVariables.user.id}")
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:onWillPop,
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
                   onPageChanged: (ind){
                     bottomNavigationBarIndex = ind;
                     setState(() {
                     });
                   },

                   physics:PageScrollPhysics() ,
                  children: [
                    HomeScreen(),
                    MyProfileNewScreen(),
                    ElitesAdvertisersScreen(),
                    NotificationsScreen(
                    ),
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
                                  bottomNavigationBarIndex = 2;
                                  pageController.jumpToPage(bottomNavigationBarIndex);

                                  setState(() {

                                  });
                                },
                              ),
                              CBr(),
                              if(GlobalVariables.user.type != 'customer')
                                ListTile(
                                  title: Text('Elite Packages'.tr),
                                  leading: Image(
                                    image: assets['diamondOutline'],
                                  ),
                                  minLeadingWidth: 0,
                                  onTap: () {
                                    /// Redirect
                                    Get.toNamed('/elites/packages');
                                  },
                                ),
                              if(GlobalVariables.user.type != 'customer')
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
                                title: Text('Proposals Requests'.tr),
                                leading: Image(
                                  image: assets['proposalsOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/proposals');
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Saved Posts'.tr),
                                leading: Image(
                                  image: assets['savedOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/posts/saved');
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Messages'.tr),
                                leading: Image(
                                  image: assets['chatsOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  Get.toNamed('/chats');
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
                                              final box = GetStorage();
                                              box.write('cate', null);
                                              box.write('country',null);
                                              /// Set index to main
                                              bottomNavigationBarIndex = 0;

                                              appLanguage.updateLocale('ar');
                                              AppServices.changeLanNotification(lan: 'ar');
                                            }

                                            Get.back();
                                          },
                                        ),
                                        CBr(),
                                        ListTile(
                                          title: Center(child: Text('English'.tr)),
                                          onTap: () {

                                            if (appLanguage.userLocale != 'en') {
                                              final box = GetStorage();
                                              box.write('cate', null);
                                              box.write('country',null);
                                              /// Set index to main
                                              bottomNavigationBarIndex = 0;
                                              appLanguage.updateLocale('en');
                                              AppServices.changeLanNotification(lan: 'en');
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
                                title: Text('Rate the app'.tr),
                                leading: Image(
                                  image: assets['starOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () async {
                                  /// Start loading


                                  /// Check if in app review is available
                                  if (await inAppReview.isAvailable()) {
                                    if(Platform.isAndroid)
                                      inAppReview.openStoreListing();
                                    else
                                      inAppReview.requestReview();

                                  }

                                  /// Stop loading

                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Text('Logout'.tr),
                                leading: Image(
                                  image: assets['logoutOutline'],
                                ),
                                minLeadingWidth: 0,
                                onTap: () {
                                  CConfirmDialog(
                                    confirmText: 'Logout'.tr,
                                    confirmCallback: () {
                                      /// Set index to main
                                      bottomNavigationBarIndex = 0;

                                      Authentication.logout(
                                        showReLoginDialog: false,
                                      );

                                      /// Go to login
                                      Get.offAllNamed('/auth/login');
                                    },
                                  );
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
            currentIndex: bottomNavigationBarIndex,
            iconSize: 30,
            onTap: (int index) {
              /// Handle More Tap
              if (index != bottomNavigationBarIndex) {
                /// Set index
                bottomNavigationBarIndex = index;
                HapticFeedback.lightImpact();
                pageController.jumpToPage(bottomNavigationBarIndex);
                setState(() {
                });
              }
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.home,
                ),
                label: 'Home'.tr,
                tooltip: 'Home'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Account'.tr,
                tooltip: 'My Account'.tr,
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
                icon: StreamBuilder<DocumentSnapshot>(
                    stream: notificationsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      var counter = 0;

                      if (snapshot.hasError) {
                        return Icon(Icons.notifications);
                      }

                      try {
                        if (snapshot.data?.get('count') != null &&
                            snapshot.data?.get('count') >= 0) {
                          /// Vibrate
                          //HapticFeedback.mediumImpact();

                          counter = snapshot.data?.get('count');
                          NotificationsHelper.setBadge(counter);
                        }
                      } catch (e) {}

                      return counter > 0
                          ? Badge(
                        badgeColor: Colors.redAccent,
                        badgeContent: Text(
                          FilterHelper.formatNumbers(counter),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Icon(Icons.notifications),
                      )
                          : Icon(Icons.notifications);
                    }),
                label: 'Notifications'.tr,
                tooltip: 'Notifications'.tr,
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
                        bottomNavigationBarIndex = 2;


                        pageController.jumpToPage(bottomNavigationBarIndex);
                        scaffoldKey.currentState!.openEndDrawer();
                        setState(() {

                        });
                      },
                    ),
                    CBr(),
                    if(GlobalVariables.user.type != 'customer')
                    ListTile(
                      title: Text('Elite Packages'.tr),
                      leading: Image(
                        image: assets['diamondOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        /// Redirect
                        Get.toNamed('/elites/packages');
                      },
                    ),
                    if(GlobalVariables.user.type != 'customer')
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
                      title: Text('Proposals Requests'.tr),
                      leading: Image(
                        image: assets['proposalsOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/proposals');
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Saved Posts'.tr),
                      leading: Image(
                        image: assets['savedOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/posts/saved');
                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Messages'.tr),
                      leading: Image(
                        image: assets['chatsOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        Get.toNamed('/chats');
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
                                    final box = GetStorage();
                                    box.write('cate', null);
                                    box.write('country',null);
                                    /// Set index to main
                                    bottomNavigationBarIndex = 0;

                                    appLanguage.updateLocale('ar');
                                    AppServices.changeLanNotification(lan: 'ar');
                                  }

                                  Get.back();
                                },
                              ),
                              CBr(),
                              ListTile(
                                title: Center(child: Text('English'.tr)),
                                onTap: () {

                                  if (appLanguage.userLocale != 'en') {
                                    final box = GetStorage();
                                    box.write('cate', null);
                                    box.write('country',null);
                                    /// Set index to main
                                    bottomNavigationBarIndex = 0;

                                    appLanguage.updateLocale('en');
                                    AppServices.changeLanNotification(lan: 'en');
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
                      title: Text('Rate the app'.tr),
                      leading: Image(
                        image: assets['starOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () async {
                        /// Start loading


                        /// Check if in app review is available
                        if (await inAppReview.isAvailable()) {
                            if(Platform.isAndroid)
                              inAppReview.openStoreListing();
                            else
                           inAppReview.requestReview();

                        }

                        /// Stop loading

                      },
                    ),
                    CBr(),
                    ListTile(
                      title: Text('Logout'.tr),
                      leading: Image(
                        image: assets['logoutOutline'],
                      ),
                      minLeadingWidth: 0,
                      onTap: () {
                        CConfirmDialog(
                          confirmText: 'Logout'.tr,
                          confirmCallback: () {
                            /// Set index to main
                            bottomNavigationBarIndex = 0;

                            Authentication.logout(
                              showReLoginDialog: false,
                            );

                            /// Go to login
                            Get.offAllNamed('/auth/login');
                          },
                        );
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
