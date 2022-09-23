import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:m3rady/core/controllers/system/languages/languages_controller.dart';
import 'package:m3rady/core/helpers/dio_helper.dart';
import 'package:m3rady/core/helpers/fcm_helper.dart';
import 'package:m3rady/core/helpers/network_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/langs/translation.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/view/theme/theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/routes/routes.dart';

late LanguageController _appLanguage;

void main() async {
  // Inform the plugin that this app supports pending purchases on Android.
  // An error will occur on Android if you access the plugin `instance`

  if (Platform.isAndroid || defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  /// Initialized
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize timezone
  tz.initializeTimeZones();

  /// Initialize storage
  await LocalStorage.init();

  /// Initialize firebase
  await Firebase.initializeApp();

  /// Initialize notifications
  /// await NotificationsHelper.init();

  /// Initialize FCM
  await FCM.init();

  /// Initialize Network
  await NetworkHelper.init();

  /// Initialize dio
  await DioHelper.init();

  /// Set languages
  _appLanguage = Get.put(LanguageController());

  /// Set Orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    /// systemNavigationBarColor: Colors.blue, // navigation bar color
    /// statusBarColor: Colors.blue, // status bar color
    statusBarColor: Colors.transparent, // status bar color
  ));

  /// Run application
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
   build(BuildContext context)  {
    return GetMaterialApp(
      title: config['appName'].toString().tr,
      getPages: routes,
      initialRoute: '/splash',
      theme: ApplicationTheme.light,
      darkTheme: ApplicationTheme.dark,
      themeMode: Get.theme.brightness == Brightness.light
          ? ThemeMode.light
          : ThemeMode.dark,
      debugShowCheckedModeBanner: config['isDebugMode'],
      enableLog: config['isDebugMode'],
      translations: Translation(),
      /// Application language
      locale: Locale(_appLanguage.userLocale),
      /// If lang not exists
      fallbackLocale: Locale(_appLanguage.defaultLocale),
    );
  }
}
