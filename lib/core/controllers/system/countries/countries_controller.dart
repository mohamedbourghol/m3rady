import 'package:get/get.dart';
import 'package:m3rady/core/models/system/countries/country.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

class AppCountries extends GetxController {
  String userCountryCode = config['usedDeviceDefaultCountry']
      ? Get.deviceLocale!.countryCode ?? config['defaultCountryCode']
      : config['defaultCountryCode'];

  String defaultCountryCode = config['defaultCountryCode'];

  List<String> countriesCodes = [];
  Map countries = {};

  @override
  void onInit() async {
    /// Get user geo ip country code
    await getAndSetUserGeoIpCountryCode();

    /// Get user default country code
    await getAndSetUserCountryCode();

    /// Get countries
    await getCountries();

    super.onInit();
  }

  Future getAndSetUserCountryCode() async {
    /// Get country code form storage if exists
    userCountryCode =
        await LocalStorage.get('userCountryCode') ?? userCountryCode;

    /// Set global vars
    GlobalVariables.systemCountryCode = userCountryCode;

    await updateUserCountryCode(userCountryCode);
  }

  Future getAndSetUserGeoIpCountryCode() async {
    /// Se user geo ip
    var geoIp = await AppServices.getUserGeoIp();

    if (geoIp != null && geoIp['status'] != false) {
      /// Set user data
      GlobalVariables.userGeoIp = geoIp['data'];

      /// Se user geo ip country code
      GlobalVariables.userGeoIpCountryCode = geoIp['data']?['countryCode'];
    }

    /// If failed to set geo ip country code
    if (GlobalVariables.userGeoIpCountryCode == null ||
        GlobalVariables.userGeoIpCountryCode == '') {
      GlobalVariables.userGeoIpCountryCode = userCountryCode;
    }
  }

  /*
   * Update locale
   */
  Future updateUserCountryCode(String code) async {
    userCountryCode = code;
    await LocalStorage.set('userCountryCode', code);
    update();
  }

  /*
   * Get countries
   */
  Future getCountries() async {
    /// Send request
    countries = await Country.getCountries();

    /// Get and set countries codes
    await getAndSetCountriesCodes();

    update();

    return countries;
  }

  /*
   * Get and set countries codes
   */
  Future getAndSetCountriesCodes() async {
    /// Get countres form countries
    countriesCodes = countries.entries.map((entries) {
      return entries.value.code.toString();
    }).toList();

    update();
  }
}
