import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/advertisers/packages/package.dart';
import 'package:m3rady/core/models/categories/category.dart';
import 'package:m3rady/core/models/users/social/social_account.dart';
import 'package:m3rady/core/models/users/social/social_login.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

/// Set user status
enum UserStatus {
  active,
  inactive,
  banned,
}

/// Set chat status
enum ChatStatus {
  public,
  followers,
  disabled,
}

/// Set profile privacy
enum ProfilePrivacy {
  public,
  followers,
  private,
}

/// Set follow status
enum FollowStatus {
  pending,
  approved,
  declined,
  unfollowed,
}

class User {
  int id;
  String? username;
  String name;
  String? fullName;
  int? businessTypeId;
  String? businessTypeName = '';
  String? email;
  String? mobile;
  String? type;
  String? imageUrl;
  String? bio;
  String? country;
  String? city;
  double? rate;
  UserStatus? accountStatus;
  bool? isElite = false;
  bool? isFollowed = false;
  bool? isSelf = false;
  SocialAccounts? socialAccounts;
  String? countryCode;
  int? cityId;
  int? mainCategoryId;
  int? subCategoryId;
  String? languageCode;
  ChatStatus? chatStatus;
  ProfilePrivacy? profilePrivacy;
  int? followersCount;
  int? followedCount;
  Map? statistics;
  Map? interestedCategories;
  double? addressLatitude;
  double? addressLongitude;
  bool? isFollowAllowed;
  bool? isAcceptedSendNotifications;
  bool? isAllowEditName;
  bool? isAllowCreatePosts;
  bool? isOnline;
  bool? isProfileCompleted;
  bool? isRated;
  FollowStatus? followStatus;
  Package? userPackage;
  bool? isHasPackage;
  bool? isAllowAddOffer;

  User({
    required this.id,
    this.username,
    required this.name,
    this.fullName,
    this.businessTypeId,
    this.businessTypeName,
    this.email,
    this.mobile,
    required this.type,
    this.imageUrl,
    this.bio,
    this.country,
    this.city,
    this.mainCategoryId,
    this.subCategoryId,
    this.rate,
    this.accountStatus,
    this.isFollowed,
    this.isElite,
    this.socialAccounts,
    this.countryCode,
    this.cityId,
    this.languageCode,
    this.chatStatus,
    this.profilePrivacy,
    this.followersCount,
    this.followedCount,
    this.statistics,
    this.interestedCategories,
    this.addressLatitude,
    this.addressLongitude,
    this.isAcceptedSendNotifications,
    this.isAllowEditName,
    this.isAllowCreatePosts,
    this.isSelf,
    this.isRated,
    this.isOnline,
    this.isProfileCompleted,
    this.followStatus,
    this.userPackage,
    this.isHasPackage,
    this.isAllowAddOffer,
  });

  /// Factory
  factory User.fromJson(Map<dynamic, dynamic> data) {
    /// Handle rate
    return User(
      id: (data['id'] ?? 0) as int,
      name: (data['name'] ?? '') as String,
      fullName:
          (data['businessTypeName'] != null && data['businessTypeName'] != ''
              ? "${data['businessTypeName']} ${data['name']}"
              : data['name']) as String,
      businessTypeId: data['businessTypeId'],
      businessTypeName: (data['businessTypeName'] ?? '') as String,
      username: (data['username'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      mobile: (data['mobile'] ?? '') as String,
      type: (data['type'] ?? 'guest') as String,
      imageUrl: (data['imageUrl'] ?? '') as String,
      bio: (data['bio'] ?? '') as String,
      rate:
          (data['rate'] == null ? 0.0 : double.parse(data['rate'].toString())),
      country: (data['country'] ?? '') as String,
      city: (data['city'] ?? '') as String,
      countryCode: (data['countryCode'] ?? '') as String,
      cityId: data['cityId'],
      mainCategoryId: data['mainCategoryId'],
      subCategoryId: data['subCategoryId'],
      languageCode:
          (data['language']?['code'] ?? config['defaultLocale']) as String,
      socialAccounts: data['socialAccounts'] != null
          ? SocialAccounts.fromJson(data['socialAccounts'])
          : null,
      statistics: data['statistics'],
      interestedCategories: data['interestedCategories'] != null
          ? Category.generateMapWithIdFromJson(data['interestedCategories'])
          : null,
      addressLatitude: data['addressLatitude'],

      /// ?? 21.4858,
      addressLongitude: data['addressLongitude'],

      /// ?? 39.1925,
      accountStatus: getAccountStatusFromJson(data['accountStatus']),
      chatStatus: getChatStatusFromJson(data['chatStatus']),
      profilePrivacy: getProfilePrivacyFromJson(data['profilePrivacy']),
      followStatus: data['followStatus'] != null
          ? getFollowStatusFromJson(data['followStatus'])
          : FollowStatus.unfollowed,
      followersCount: (data['followersCount'] ?? 0) as int,
      followedCount: (data['followedCount'] ?? 0) as int,
      isFollowed: (data['isFollowed'] ?? false) as bool,
      isAcceptedSendNotifications:
          (data['isAcceptedSendNotifications'] ?? false) as bool,
      isAllowEditName: (data['isAllowEditName'] ?? false) as bool,
      isAllowCreatePosts: (data['isAllowCreatePosts'] ?? false) as bool,
      isElite: (data['isElite'] ?? false) as bool,
      isSelf: (data['isSelf'] ?? false) as bool,
      isOnline: (data['isOnline'] ?? false) as bool,
      isRated: (data['isRated'] ?? false) as bool,
      isProfileCompleted: (data['isProfileCompleted'] ?? true) as bool,
      userPackage: data['userPackage'] != null
          ? Package.fromJson(data['userPackage'])
          : null,
      isHasPackage: (data['userPackage'] != null),
      isAllowAddOffer: data['isAllowAddOffer'] == true,
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = User.fromJson(value);

        /// Set data
        data["${entry.type}.${entry.id}"] = entry;
      });
    }

    return data;
  }

  /// Get account status from json
  static UserStatus getAccountStatusFromJson(data) {
    UserStatus status = UserStatus.active;
    switch (data) {
      case ('banned'):
        status = UserStatus.banned;
        break;
      case ('inactive'):
        status = UserStatus.inactive;
        break;
    }

    return status;
  }

  /// Get follow status from json
  static FollowStatus getFollowStatusFromJson(data) {
    FollowStatus status = FollowStatus.unfollowed;
    switch (data) {
      case ('pending'):
        status = FollowStatus.pending;
        break;
      case ('approved'):
        status = FollowStatus.approved;
        break;
      case ('declined'):
        status = FollowStatus.declined;
        break;
    }

    return status;
  }

  /// Get profile privacy from json
  static ProfilePrivacy getProfilePrivacyFromJson(data) {
    ProfilePrivacy status = ProfilePrivacy.private;
    switch (data) {
      case ('public'):
        status = ProfilePrivacy.public;
        break;
      case ('followers'):
        status = ProfilePrivacy.followers;
        break;
    }
    return status;
  }

  /// Get chat status from json
  static ChatStatus getChatStatusFromJson(data) {
    ChatStatus status = ChatStatus.disabled;
    switch (data) {
      case ('public'):
        status = ChatStatus.public;
        break;
      case ('disabled'):
        status = ChatStatus.disabled;
        break;
      case ('followers'):
        status = ChatStatus.followers;
        break;
    }

    return status;
  }

  /// Get user data
  static Future getUserData() async {
    var data = await AppServices.getUserData();

    if (data['status'] == true) {
      return User.fromJson(data['data']);
    }

    return false;
  }

  /// Get and set user global data
  static Future getAndSetUserGlobalData() async {
    var data = await getUserData();

    if (data != false) {
      GlobalVariables.user = data;
      GlobalVariables.userDataUpdatesCounter.value++;
    }

    return data;
  }

  /// Get user social login
  static Future getUserSocialLogin() async {
    var data = await AppServices.getUserSocialLogin();

    if (data['status'] == true) {
      return SocialLogin.generateMapWithIdFromJson(data['data']);
    }

    return false;
  }

  /// Add user social login
  static Future addUserSocialLogin({
    required String provider,
    required String providerId,
  }) async {
    var data = await AppServices.addUserSocialLogin(
        provider: provider, providerId: providerId);

    /// Error
    if (data['status'] != true) {
      CErrorDialog(errors: data['message']);
      return false;
    }

    /// Success
    CSentSuccessfullyDialog(text: data['message']);

    return true;
  }

  /// Delete user social login
  static Future deleteUserSocialLogin({
    required String provider,
  }) async {
    var data = await AppServices.deleteUserSocialLogin(provider: provider);

    /// Error
    if (data['status'] != true) {
      CErrorDialog(errors: data['message']);
      return false;
    }

    return true;
  }

  /// Update user data
  static Future updateUserData({
    String? businessTypeId,
    String? name,
    String? bio,
    String? mobile,
    String? email,
    String? username,
    String? password,
    String? oldPassword,
    String? countryCode,
    String? cityId,
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
  }) async {
    var data = await AppServices.updateUserData(
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

    if (data['status'] == true) {
      /// Update user data
      await getAndSetUserGlobalData();

      return data;
    }

    return false;
  }

  /// delete user
  static Future deleteUserData({
    String? password,

  }) async {
    var data = await AppServices.deleteUser(
      password: password,

    );

    if (data['status'] == true) {


      return data;
    }

    return false;
  }

  /// Update username request
  static Future updateUsernameRequest({
    required String newUsername,
    required String reason,
  }) async {
    var data = await AppServices.updateUsernameRequest(
      newUsername: newUsername,
      reason: reason,
    );

    if (data['status'] == true) {
      /// Saved dialog
      CSentSuccessfullyDialog(
        text: data['message'],
      );

      return true;
    }

    return false;
  }

  /// Check authentication
  static Future check() async {
    /// Send check request
    var check = await AppServices.check();

    if (check['status'] == true) {
      return check['data']['user'];
    }

    return false;
  }

  /// Login account
  static Future loginAccount({
    required String login,
    required String password,
    String? fcmToken,
  }) async {
    /// Send request
    var auth = await AppServices.loginAccount(
      login: login,
      password: password,
      fcmToken: fcmToken,
    );

    if (auth['status'] == true) {
      return auth['data'];
    }

    return false;
  }

  /// Login social
  static Future loginSocial({
    required String provider,
    required String providerId,
    String? fcmToken,
  }) async {
    /// Send request
    var auth = await AppServices.loginSocial(
      provider: provider,
      providerId: providerId,
      fcmToken: fcmToken,
    );

    if (auth['status'] == true) {
      return auth['data'];
    } else {
      /// Check auth
      CConfirmDialog(
        contentWidget: Column(
          children: auth['data']!['errors'].map<Widget>((error) {
            return Column(
              children: [
                Text(
                  error,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            );
          }).toList(),
        ),
        confirmCallback: () {
          Get.back();
          Get.toNamed('/auth/account-type', arguments: {
            'provider': provider,
            'providerId': providerId,
            'fcmToken': fcmToken,
          });
        },
        autoClose: false,
        confirmText: 'Register'.tr,
        confirmTextColor: Colors.green,
      );
    }

    return false;
  }

  /// Login social
  static Future logout() async {
    /// Send request
    return await AppServices.logout();
  }

  /// Register
  static Future register({
    required type,
    required name,
    businessTypeId,
    required mobile,
    email,
    username,
    required password,
    required countryCode,
    required cityId,
    required interestedCategories,
    fcmToken,
    isAcceptedSendNotifications,
    mobileVerificationCode,
    isRequestMobileVerificationCode,
    provider,
    providerId,
  }) async {
    /// Send request
    var auth = await AppServices.register(
      type: type,
      interestedCategories: interestedCategories,
      name: name,
      businessTypeId: businessTypeId,
      mobile: mobile,
      email: email,
      username: username,
      password: password,
      countryCode: countryCode,
      cityId: cityId,
      fcmToken: fcmToken,
      isAcceptedSendNotifications: isAcceptedSendNotifications,
      mobileVerificationCode: mobileVerificationCode,
      isRequestMobileVerificationCode: isRequestMobileVerificationCode,
      provider: provider,
      providerId: providerId,
    );
       print("auth");
    print(auth);
    print("auth");
    if (auth['status'] == true) {
      return auth['data'];
    }

    return false;
  }

  /// Get advertiser
  static Future getAdvertiser(id) async {
    var user = await AppServices.getAdvertiser(id);

    if (user['status'] == true) {
      return User.fromJson(user['data']);
    }

    return false;
  }

  /// Get customer
  static Future getCustomer(id) async {
    var user = await AppServices.getCustomer(id);

    if (user['status'] == true) {
      return User.fromJson(user['data']);
    }

    return false;
  }

  /// Follow advertiser
  static Future toggleFollowAdvertiser(id, isFollow) async {
    var follow = await AppServices.toggleFollowUser(
      id: id,
      type: 'advertiser',
      isFollow: isFollow,
    );

    if (follow['status'] == true) {
      return {
        'message': follow['message'],
        'data': follow['data'],
      };
    }

    return false;
  }

  /// Follow customer
  static Future toggleFollowCustomer(id, isFollow) async {
    var follow = await AppServices.toggleFollowUser(
      id: id,
      type: 'customer',
      isFollow: isFollow,
    );

    if (follow['status'] == true) {
      return {
        'message': follow['message'],
        'data': follow['data'],
      };
    }

    return false;
  }

  /// Get advertisers (pagination)
  static Future getAdvertisers({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var users = await AppServices.getAdvertisers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (users['status'] == true) {
      data['data'] = generateMapWithIdFromJson(users['data']);
      data['pagination'] = users['pagination'];
    }

    return data;
  }

  /// Get advertisers (pagination)
  static Future getAdvertisersSearch({
    int? limit,
    int? page,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var users = await AppServices.getAdvertisersSearch(
      limit: limit,
      page: page,
      keyword: keyword,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (users['status'] == true) {
      data['data'] = generateMapWithIdFromJson(users['data']);
      data['pagination'] = users['pagination'];
    }

    return data;
  }

  /// get elite advertisers (pagination)
  static Future getEliteAdvertisers({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var users = await AppServices.getEliteAdvertisers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (users['status'] == true &&
        users['data'] != null &&
        data['pagination'] != null) {
      data['data'] = generateMapWithIdFromJson(users['data']);
      data['pagination'] = users['pagination'];
    }

    /// Ping user
    if (GlobalVariables.isUserAuthenticated.value == true) {
      AppServices.pingUser();
    }

    return data;
  }

  /// Ping user
  static Future pingUser() async {
    await AppServices.pingUser();
  }

  /// Reset password
  static Future resetPassword({
    required mobile,
    uid,
    password,
    sendResetSms,
    smsOtp
  }) async {
    var reset = await AppServices.resetPassword(
      mobile: mobile,
      uid: uid,
      password: password,
      sendResetSms: sendResetSms,
        smsOtp: smsOtp,

    );

    if (reset['status'] == true) {
      return {
        'message': reset['message'],
        'data': reset['data'],
      };
    }

    return false;
  }

  /// Block user
  static Future toggleBlockUser({
    required id,
    required  type,
    isBlocked,
  }) async {
    var block = await AppServices.toggleBlockUser(
      id: id,
      type: type,
      isBlocked: isBlocked,
    );

    if (block['status'] == true) {
      return {
        'message': block['message'],
        'data': block['data'],
      };
    }

    return false;
  }

  /// Report user
  static Future reportUser({
    required id,
    required  type,
    reportType,
    reportReason,
  }) async {
    var block = await AppServices.reportUser(
      id: id,
      type: type,
      reportType: reportType,
      reportReason: reportReason,
    );

    if (block['status'] == true) {
      return {
        'message': block['message'],
        'data': block['data'],
      };
    }

    return false;
  }

  /// Get block list (pagination)
  static Future getUserBlockList({
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var users = await AppServices.getUserBlockList(
      limit: limit,
      page: page,
    );

    if (users['status'] == true) {
      data['data'] = generateMapWithIdFromJson(users['data']);
      data['pagination'] = users['pagination'];
    }

    return data;
  }
}
