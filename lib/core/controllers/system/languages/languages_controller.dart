import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/system/countries/countries_controller.dart';
import 'package:m3rady/core/helpers/dio_helper.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

class LanguageController extends GetxController {
  final AppCountries appCountries = Get.put(AppCountries());

  String userLocale = config['usedDeviceDefaultLocale']
      ? Get.deviceLocale!.languageCode
      : config['defaultLocale'];

  String defaultLocale = config['defaultLocale'];

  @override
  void onReady() async {
    super.onReady();

    /// Get and set app language
    await getAndSetAppLocale();
  }

/*
 * Get and set app locale 
 */
  Future getAndSetAppLocale() async {
    /// Get local form storage if exists
    userLocale = await LocalStorage.get('userLocale') ?? userLocale;

    await updateLocale(userLocale);
  }

  /*
   * Update locale
   */
  Future updateLocale(String code) async {
    /// Restart
    Get.offAllNamed('/splash');

    userLocale = code;
    await LocalStorage.set('userLocale', code);
    Get.updateLocale(Locale(code));

    /// Re-init Dio
    await DioHelper.init();

    /// Get countries
    await Get.find<AppCountries>().getCountries();

    /// Get user default country code
    await Get.find<AppCountries>().getAndSetUserCountryCode();

    /// Update user data
    if (GlobalVariables.isUserAuthenticated.value == true) {
      await User.updateUserData(
        languageCode: code,
        showRequestErrors: false,
      );
    }

    /// Update
    update();
  }
}
