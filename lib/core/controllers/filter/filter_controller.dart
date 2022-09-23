import 'package:get/get.dart';
import 'package:m3rady/core/controllers/system/countries/countries_controller.dart';

class FilterController extends GetxController {
  var isFilterShowPosts = true.obs;
  var isShowFilter = true.obs;
  var countries = {}.obs;
  var cities = {}.obs;
  var selectedCountryCode = ''.obs;
  var selectedCityId = ''.obs;

  FilterController({
    isFilterShowPosts = true,
  }) {
    this.isFilterShowPosts.value = isFilterShowPosts;
  }

  @override
  void onReady() async {
    super.onReady();

    /// Get and set countries
    await getAndSetCountries();
  }

/*
 * Get And Set Countries (API)
 */
  Future getAndSetCountries() async {
    AppCountries countriesController = Get.find<AppCountries>();

    /// Reset values
    selectedCountryCode.value = '';
    selectedCityId.value = '';

    /// Get countries
    countries.value = countriesController.countries;
  }

  /*
 * Get And Set cities By Country Code (API)
 */
  Future getAndSetCitiesByCountryCode(code) async {
    /// Get cities
    if (code == '') {
      cities.value = {};
    } else {
      cities.value = countries[code]!.cities!;
    }
  }

/*
 * Change the selected country
 */
  void changeSelectedCountry(code) async {
    if (selectedCountryCode.value != code) {
      selectedCountryCode.value = code.toString();

      /// Remove selected city
      selectedCityId.value = '';

      /// Get cities form current country
      await getAndSetCitiesByCountryCode(code);
    }
  }

  /*
 * Change the selected city
 */
  void changeSelectedCity(id) async {
    selectedCityId.value = id.toString();
  }
}
