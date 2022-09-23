import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/categories/categories_controller.dart';
import 'package:m3rady/core/controllers/system/countries/countries_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

class AccountController extends GetxController {
  CategoriesController categoriesController = Get.put(CategoriesController());
  GlobalKey<FormState> updateAccountFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateUsernameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateSocialAccountsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> accountPrivacyFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> chatPrivacyFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> disableAccountFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileVerifyFormKey = GlobalKey<FormState>();
  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController usernameRequestController = TextEditingController();
  TextEditingController usernameRequestReasonController =
      TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmationController =
      TextEditingController();


  TextEditingController mobileController = TextEditingController();
  TextEditingController mobileFullController = TextEditingController();
  TextEditingController mobileVerificationCodeController =
      TextEditingController();

  TextEditingController whatsappMobileController = TextEditingController();
  TextEditingController contactMobileController = TextEditingController();
  TextEditingController facebookLinkController = TextEditingController();
  TextEditingController twitterLinkController = TextEditingController();
  TextEditingController websiteLinkController = TextEditingController();

  bool oldPasswordVisibility = false;
  bool passwordVisibility = false;
  bool passwordConfirmationVisibility = false;
  bool isMobileVerifyHasError = false;
  bool isVerifyingMobile = false;
  var verifyingResendCodeTimer;
  int verifyingResendCodeTimerValue = 0;
  int resendMobileVerificationCodeTimes = 0;

  Map countries = {};
  Map cities = {};
  String? selectedCountryCode = GlobalVariables.user.countryCode;
  String? selectedCityId = GlobalVariables.user.cityId.toString();

  Map categories = {};
  Map subCategories = {};

  Map? interestedCategories = GlobalVariables.user.interestedCategories;
  Map selectedInterestedCategories = {};

  String selectedProfilePrivacy = GlobalVariables.user.profilePrivacy
      .toString()
      .replaceAll('ProfilePrivacy.', '');

  String selectedChatPrivacy =
      GlobalVariables.user.chatStatus.toString().replaceAll('ChatStatus.', '');

  String selectedAccountStatus = GlobalVariables.user.accountStatus
      .toString()
      .replaceAll('UserStatus.', '');

  var user;
  var userSocialLoginAccounts;
  var isLoadingProfile = true.obs;

  bool loadCountries = true;
  bool loadCategories = true;
  bool loadSocialLogin = true;
  bool loadAccount = true;

  AccountController({
    this.loadCountries = true,
    this.loadCategories = true,
    this.loadSocialLogin: true,
    this.loadAccount: true,
  });

  @override
  void onReady() async {
    super.onReady();

    /// Start loader
    isLoadingProfile.value = true;

    /// Set user
    user = GlobalVariables.user;

    /// Get account
    if (loadAccount == true) {
      await User.getAndSetUserGlobalData();
    }

    /// Set user interested categories
    int selectedInterestedCategoriesIndex = 0;
    user.interestedCategories.forEach((key, category) {
      selectedInterestedCategories.addAll({
        selectedInterestedCategoriesIndex.toString(): category.id.toString(),
      });
      selectedInterestedCategoriesIndex++;
    });

    /// Get and set countries
    if (loadCountries == true) {
      await getAndSetCountries();
      await getAndSetCitiesByCountryCode(selectedCountryCode);
    }

    /// Set user categories
    if (loadCategories == true) {
      categories = await categoriesController.getCategories();
      if (user.mainCategoryId != null) {
        subCategories =
            categories[user.mainCategoryId.toString()].subCategories;
      }
    }

    /// Set user social login
    if (loadSocialLogin == true) {
      userSocialLoginAccounts = await User.getUserSocialLogin();
    }

    /// Set user data in the controllers
    bioController.text = user.bio ?? '';
    nameController.text = user.name;
    usernameController.text = user.username ?? '';
    emailController.text = user.email ?? '';

    /// Set social contact
    if (user.socialAccounts != null) {
      whatsappMobileController.text = user.socialAccounts?.contactNumber ?? '';
      contactMobileController.text = user.socialAccounts?.whatsappNumber ?? '';
      facebookLinkController.text = user.socialAccounts?.facebookUrl ?? '';
      twitterLinkController.text = user.socialAccounts?.twitterUrl ?? '';
      websiteLinkController.text = user.socialAccounts?.websiteUrl ?? '';
    }

    /// Stop loader
    isLoadingProfile.value = false;

    update();
  }

/*
 * Get And Set Countries (API)
 */
  Future getAndSetCountries() async {
    AppCountries countriesController = Get.find<AppCountries>();

    /// Get countries
    countries = await countriesController.getCountries();

    update();
  }

  /*
 * Get And Set cities By Country Code (API)
 */
  Future getAndSetCitiesByCountryCode(code) async {
    /// Get cities
    cities = countries[code]!.cities!;

    update();
  }

/*
 * Toggle old password visibility
 */
  void toggleOldPasswordVisibility() {
    oldPasswordVisibility = !oldPasswordVisibility;
    update();
  }

  /*
 * Toggle password visibility
 */
  void togglePasswordVisibility() {
    passwordVisibility = !passwordVisibility;
    update();
  }

/*
 * Toggle password confirmation visibility
 */
  void togglePasswordConfirmationVisibility() {
    passwordConfirmationVisibility = !passwordConfirmationVisibility;
    update();
  }

/*
 * Change the selected profile privacy
 */
  void changeSelectedProfilePrivacy(data) async {
    data = data.toString();

    selectedProfilePrivacy = data;

    update();
  }

/*
 * Change the selected chat privacy
 */
  void changeSelectedChatPrivacy(data) async {
    data = data.toString();

    selectedChatPrivacy = data;

    update();
  }

  /*
 * Change the selected account status
 */
  void changeSelectedAccountStatus(data) async {
    data = data.toString();

    selectedAccountStatus = data;

    update();
  }

  /*
 * Change the selected main category
 */
  /*void changeSelectedMainCategory(id) async {
    id = id.toString();

    subCategories = categories[id].subCategories;

    selectedSubCategoryId = null;
    selectedMainCategoryId = id;

    update();
  }*/

  /*
 * Change the selected sub category
 */
  /*void changeSelectedSubCategory(id) async {
    selectedSubCategoryId = id.toString();

    update();
  }*/

  /*
 * Change the selected country
 */
  void changeSelectedCountry(code) async {
    if (selectedCountryCode != code) {
      selectedCountryCode = code;

      /// Remove selected city
      selectedCityId = null;

      /// Get cities form current country
      await getAndSetCitiesByCountryCode(code);
    }

    update();
  }

  /*
 * Change the selected city
 */
  void changeSelectedCity(id) async {
    selectedCityId = id.toString();
    update();
  }



  /// Update account
  Future updateAccount({
    String? businessTypeId,
    String? name,
    String? bio,
    String? mobile,
    String? email,
    String? username,
    String? password,
    String? oldPassword,
    String? countryCode,
    cityId,
    Map? interestedCategories,
    String? languageCode,
    String? contactNumber,
    String? whatsappNumber,
    String? facebookUrl,
    String? twitterUrl,
    String? websiteUrl,
    String? addressLatitude,
    String? addressLongitude,
    String? chatStatus,
    String? profilePrivacy,
    bool? isAcceptedSendNotifications,
    File? image,
    bool? deleteImage,
    bool? isDisableAccount,
    bool? showRequestErrors = true,
    bool? showSuccess = true,
  }) async {
    /// Start loader
    MainLoader.set(false);

    /// Update user
    var request = await User.updateUserData(
      businessTypeId: businessTypeId,
      name: name,
      bio: bio,
      mobile: mobile,
      email: email,
      username: username,
      password: password,
      oldPassword: oldPassword,
      countryCode: countryCode,
      cityId: cityId,
      interestedCategories: interestedCategories,
      languageCode: languageCode,
      contactNumber: contactNumber,
      whatsappNumber: whatsappNumber,
      facebookUrl: facebookUrl,
      twitterUrl: twitterUrl,
      websiteUrl: websiteUrl,
      addressLatitude: addressLatitude,
      addressLongitude: addressLongitude,
      chatStatus: chatStatus,
      profilePrivacy: profilePrivacy,
      isAcceptedSendNotifications: isAcceptedSendNotifications,
      image: image,
      deleteImage: deleteImage,
      isDisableAccount: isDisableAccount,
      showRequestErrors: showRequestErrors,
    );

    if (request != false && showSuccess == true) {
      /// Saved dialog
      if (showRequestErrors == true) {
        CSentSuccessfullyDialog(
            text: request['message'],
            callback: () {
              Get.back();
            });
      }
    }

    /// Stop loader
    MainLoader.set(false);

    /// Set user
    user = GlobalVariables.user;

    /// Update
    update();

    return user;
  }


  /// Update account
  Future deleteAccount({

    String? password,

  }) async {
    /// Start loader
    MainLoader.set(true);

    /// Update user
    var request = await User.deleteUserData(
      password: password,

    );

    if (request != false ) {

      /// Go to login
      Get.offAllNamed('/auth/login');

    }

    /// Stop loader
    MainLoader.set(false);

    /// Set user
    user = GlobalVariables.user;

    /// Update
    update();

    return user;
  }

  /// Update username request
  Future updateUsernameRequest({
    required String newUsername,
    required String reason,
  }) async {
    /// Start loader
    MainLoader.set(true);

    await User.updateUsernameRequest(
      newUsername: newUsername,
      reason: reason,
    );

    /// Stop loader
    MainLoader.set(false);

    /// Update
    update();
  }

  /// Add user social login
  Future addUserSocialLogin({
    required String provider,
    required String providerId,
  }) async {
    /// Start loader
    MainLoader.set(true);

    await User.addUserSocialLogin(
      provider: provider,
      providerId: providerId,
    );

    /// Get social accounts
    userSocialLoginAccounts = await User.getUserSocialLogin();

    /// Stop loader
    MainLoader.set(false);

    /// Update
    update();
  }

  /// Delete user social login
  Future deleteUserSocialLogin({
    required String provider,
  }) async {
    /// Start loader
    MainLoader.set(true);

    await User.deleteUserSocialLogin(
      provider: provider,
    );

    /// Get social accounts
    userSocialLoginAccounts = await User.getUserSocialLogin();

    /// Stop loader
    MainLoader.set(false);

    /// Update
    update();
  }

  /// Get block list
  Future getBlockList({
    int? limit,
    int? page,
  }) async {
    return await User.getUserBlockList(
      limit: limit,
      page: page,
    );
  }

  /// Toggle block user
  Future toggleBlockUser({
    required id,
    required type,
    isBlocked,
  }) async {
    var block = await User.toggleBlockUser(
      id: id,
      type: type,
      isBlocked: isBlocked,
    );

    if (block != false) {
      CToast(text: block['message']);
    }
  }
}
