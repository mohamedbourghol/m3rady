import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:m3rady/core/helpers/dio_helper.dart';

class AppServices {
  /* Main */
  static setAutoShowErrors(show) => DioHelper.isAutoShowErrors = show;

  /* ***************************************************************** */

  /* System */

  /// Get Business Types
  static Future getBusinessTypes() async {
    return await DioHelper.get('system/business-types');
  }

  /// Get Countries
  static Future getCountries() async {
    return await DioHelper.get('system/countries');
  }

  /* ***************************************************************** */

  /* GeoIp */

  /// Get user geo ip
  static Future getUserGeoIp() async {
    return await DioHelper.get("system/geoip");
  }

  /* ***************************************************************** */


  /* ***************************************************************** */

  /* GeoModals */

  /// Get user geo ip
  static Future getModals() async {
    return await DioHelper.get("modals/get",
    applyUserTypeInUrl: true
    );
  }

  /* ***************************************************************** */

  /* Pages*/

  /// Get Page by slug
  static Future getPageBySlug(String slug) async {
    return await DioHelper.get("pages/$slug");
  }

  /* ***************************************************************** */

  /* Auth */

  /// login with account
  static Future loginAccount({
    required String login,
    required String password,
    String? fcmToken,
  }) async {
    /// Send request
    return await DioHelper.post(
      'auth/login',
      parameters: {
        'login': login,
        'password': password,
        'fcmToken': fcmToken,
      },
    );
  }

  /// login with social
  static Future loginSocial({
    required String provider,
    required String providerId,
    String? fcmToken,
  }) async {
    /// Send request
    return await DioHelper.post(
      'auth/login',
      parameters: {
        'provider': provider,
        'providerId': providerId,
        'fcmToken': fcmToken,
      },
    );
  }

  /// register
  static Future register({
    required type,
    required name,
    required interestedCategories,
    businessTypeId,
    required mobile,
    email,
    username,
    required password,
    required countryCode,
    required cityId,
    fcmToken,
    isAcceptedSendNotifications,
    mobileVerificationCode,
    required isRequestMobileVerificationCode,
    provider,
    providerId,
  }) async {
    debugPrint(isRequestMobileVerificationCode.toString());
    /// Start show errors
    DioHelper.isAutoShowErrors = true;

    return await DioHelper.post(
      'auth/register',
      parameters: {
        'type': type,
        'name': name,
        'businessTypeId':
            (businessTypeId != null ? int.parse(businessTypeId) : null),
        'mobile': mobile,
        'email': email,
        'username': username,
        'password': password,
        'countryCode': countryCode,
        'cityId': (cityId != null ? int.parse(cityId) : null),
        'fcmToken': fcmToken,
        'isAcceptedSendNotifications': 1 ,
        'interestedCategories': interestedCategories,
        if(mobileVerificationCode!=null)
        'mobileVerificationCode':mobileVerificationCode,
        'isRequestMobileVerificationCode':isRequestMobileVerificationCode?1:0,
        'provider': provider,
        'providerId': providerId,
      },
    );
  }

  /// Reset password
  static Future resetPassword({
    required mobile,
    uid,
    password,
    sendResetSms,
    smsOtp
  }) async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = true;
    return await DioHelper.post(
      'auth/password/forget',
      parameters: {
        'mobile': mobile,
        if(uid!=null)
        'uid': uid,
        'password': password,
        if(sendResetSms!=null)
        'send_reset_sms': sendResetSms,
        if(smsOtp!=null)
        'sms_otp': smsOtp,
      },
    );
  }

  /// check
  static Future check() async {
    return await DioHelper.get('auth/check');
  }

  /// logout
  static Future logout() async {
    return await DioHelper.post('auth/logout');
  }

  /* ***************************************************************** */
  /* Users */

  /// ping user
  static Future pingUser() async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = false;

    return await DioHelper.post(
      'ping',
      applyUserTypeInUrl: true,
    );
  }

  /// Toggle follow user
  static Future toggleFollowUser({
    required id,
    required type,
    isFollow,
  }) async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = false;
    return await DioHelper.post(
      'users/followings',
      parameters: {
        'userType': type,
        'userId': id,
        'isFollowed': isFollow == true ? 1 : 0,
      },
    );
  }

  /// Toggle block user
  static Future toggleBlockUser({
    required id,
    required type,
    isBlocked,
  }) async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = false;
    return await DioHelper.post(
      'users/block',
      parameters: {
        'userType': type,
        'userId': id,
        'isBlocked': isBlocked == true ? 1 : 0,
      },
    );
  }

  /// Report user
  static Future reportUser({
    required id,
    required type,
    reportType,
    reportReason,
  }) async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = false;
    return await DioHelper.post(
      'users/report',
      parameters: {
        'userType': type,
        'userId': id,
        'reportType': reportType,
        'reportReason': reportReason,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get block list
  static Future getUserBlockList({
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'users/blocked',
      parameters: {
        'limit': limit,
        'page': page,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get advertiser
  static Future getAdvertiser(id) async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = false;
    return await DioHelper.get(
      'advertisers/$id',
      applyUserTypeInUrl: true,
    );
  }

  /// Get rates by advertiser id (pagination)
  static Future getRatesByAdvertiserId(
    id, {
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'advertisers/$id/raters',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Rate advertiser by id
  static Future rateAdvertiserById({
    required id,
    required rate,
    comment,
  }) async {
    return await DioHelper.post(
      'advertisers/$id/rate',
      parameters: {
        'rate': rate,
        'comment': comment,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Hide advertiser's posts, offers,...
  static Future hideAdvertiserById(
    id, {
    bool? isHidden,
  }) async {
    return await DioHelper.post(
      'advertisers/$id/hide',
      parameters: {
        'isHidden': isHidden == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get customer
  static Future getCustomer(id) async {
    /// Stop show errors
    DioHelper.isAutoShowErrors = false;
    return await DioHelper.get(
      'customers/$id',
      applyUserTypeInUrl: true,
    );
  }

  /// Get advertisers
  static Future getAdvertisers({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await DioHelper.get(
      'advertisers',
      limit: limit,
      page: page,
      parameters: {
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get advertisers search
  static Future getAdvertisersSearch({
    int? limit,
    int? page = 1,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    /// Handle data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'limit': limit,
        'page': page,
        'keyword': keyword,
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
    );

    return await DioHelper.post(
      'advertisers/search',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Get elite advertisers
  static Future getEliteAdvertisers({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await DioHelper.get(
      'advertisers/elite',
      limit: limit,
      page: page,
      parameters: {
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get user data
  static Future getUserData() async {
    return await DioHelper.get(
      'account',
      applyUserTypeInUrl: true,
    );
  }

  /// Get user social login
  static Future getUserSocialLogin() async {
    return await DioHelper.get(
      'social/accounts',
    );
  }

  /// Add user social login
  static Future addUserSocialLogin({
    required String provider,
    required String providerId,
  }) async {
    return await DioHelper.post(
      'social/accounts',
      parameters: {
        'provider': provider,
        'providerId': providerId,
      },
    );
  }

  /// Delete user social login
  static Future deleteUserSocialLogin({
    required String provider,
  }) async {
    return await DioHelper.delete(
      'social/accounts',
      parameters: {
        'provider': provider,
      },
    );
  }

  /// Update User data
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
    /// Start show errors
    DioHelper.isAutoShowErrors =
        (showRequestErrors != null ? showRequestErrors : true);

    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      files: image,
      fromDataAttributeName: 'image',
      data: {
        'businessTypeId': businessTypeId,
        'name': name,
        'bio': bio,
        'mobile': mobile,
        'email': email,
        'username': username,
        'password': password,
        'oldPassword': oldPassword,
        'countryCode': countryCode,
        'cityId': cityId,
        'interestedCategories': interestedCategories,
        'languageCode': languageCode,
        'contactNumber': contactNumber,
        'whatsappNumber': whatsappNumber,
        'facebookUrl': facebookUrl,
        'twitterUrl': twitterUrl,
        'websiteUrl': websiteUrl,
        'addressLatitude': addressLatitude,
        'addressLongitude': addressLongitude,
        'chatStatus': chatStatus,
        'profilePrivacy': profilePrivacy,
        'isAcceptedSendNotifications': (isAcceptedSendNotifications == null
            ? null
            : (isAcceptedSendNotifications == true ? 1 : 0)),
        'isDisableAccount': (isDisableAccount == null
            ? null
            : (isDisableAccount == true ? 1 : 0)),
        'deleteImage':
            (deleteImage == null ? null : (deleteImage == true ? 1 : 0)),
      },
    );

    return await DioHelper.post(
      'account',
      data: data,
      applyUserTypeInUrl: true,
    );
  }


  /// delete User
  static Future deleteUser({
    String? password,

    bool? showRequestErrors = true,
  }) async {
    /// Start show errors
    DioHelper.isAutoShowErrors =
    (showRequestErrors != null ? showRequestErrors : true);
    return await DioHelper.post(
      'account/delete',
    data: {
    'password': password,
    },
      applyUserTypeInUrl: true,
    );
  }

  /// Update username request
  static Future updateUsernameRequest({
    required String newUsername,
    required String reason,
  }) async {
    /// Start show errors
    DioHelper.isAutoShowErrors = true;

    return await DioHelper.post(
      'requests/username/change',
      parameters: {
        'newUsername': newUsername,
        'reason': reason,
      },
      applyUserTypeInUrl: true,
    );
  }

  /* ***************************************************************** */
  /* Community */

  /// Categories
  static Future getCategories() async {
    return await DioHelper.get(
      'categories',
      applyUserTypeInUrl: true,
    );
  }

  /* ***************************************************************** */

  /// Posts

  /// Create post
  static Future createPost({
    categoryId,
    required String content,
    Map? media,
  }) async {
    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      files: media,
      fromDataAttributeName: 'media',
      data: {
        'categoryId': categoryId,
        'content': content,
      },
    );

    return await DioHelper.post(
      'community/posts',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Update post
  static Future updatePost(
    id, {
    required categoryId,
    required String content,
  }) async {
    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'categoryId': categoryId,
        'content': content,
      },
    );

    return await DioHelper.post(
      'community/posts/$id',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Get posts advertisement (pagination)
  static Future getPostsAds({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
    isRandom = true,
  }) async {
    return await DioHelper.get(
      'advertisements',
      limit: limit,
      page: page,
      parameters: {
        'type': 'mobile',
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
        'isRandom': isRandom,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get posts (pagination)
  static Future getPosts({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await DioHelper.get(
      'community/posts',
      limit: limit,
      page: page,
      parameters: {

        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get post by id
  static Future getPostById(id) async {
    return await DioHelper.get(
      'community/posts/$id',
      applyUserTypeInUrl: true,
    );
  }

  /// Get saved posts (pagination)
  static Future getSavedPosts({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await DioHelper.get(
      'community/posts/saved',
      limit: limit,
      page: page,
      parameters: {
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get posts search (pagination)
  static Future getPostsSearch({
    int? limit,
    int? page = 1,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    /// Handle data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'limit': limit,
        'page': page,
        'keyword': keyword,
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
    );

    return await DioHelper.post(
      'community/posts/search',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Get posts by advertiser id (pagination)
  static Future getPostsByAdvertiserId({
    required int id,
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'community/posts/advertisers/$id',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Get posts by customer id (pagination)
  static Future getPostsByCustomerId({
    required int id,
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'community/posts/interacted/customer/$id',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Like post
  static Future likePost(
    int postId, {
    bool? isLiked,
  }) async {
    return await DioHelper.post(
      'community/posts/$postId/like',
      parameters: {
        'isLiked': isLiked == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Save post
  static Future savePost(
    int postId, {
    bool? isSaved,
  }) async {
    return await DioHelper.post(
      'community/posts/$postId/save',
      parameters: {
        'isSaved': isSaved == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get notifications post
  static Future getNotificationsPost(
    int postId, {
    bool? isSaved,
  }) async {
    return await DioHelper.post(
      'community/posts/$postId/save',
      parameters: {
        'isSaved': isSaved == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Subscribe post
  static Future subscribePost(
    int postId, {
    bool? isSubscribed,
  }) async {
    return await DioHelper.post(
      'community/posts/$postId/subscribe',
      parameters: {
        'isSaved': isSubscribed == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Report posts
  static Future reportPostById(
    int postId, {
    String? reason,
  }) async {
    return await DioHelper.post(
      'community/posts/reports',
      applyUserTypeInUrl: true,
      parameters: {
        'postId': postId,
        'reason': reason,
      },
    );
  }

  /// delete posts
  static Future deletePost(int postId) async {
    return await DioHelper.delete(
      'community/posts/$postId',
      applyUserTypeInUrl: true,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Posts Comments

  /// Get post comments
  static Future getPostComments(
    postId, {
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'community/posts/$postId/comments',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Add post comments
  static Future addPostComment(
    postId, {
    required String comment,
        required int commentId
  }) async {
    return await DioHelper.post(
      'community/posts/$postId/comments',
      parameters: {
        'comment': comment,
        if(commentId!=0)
          'comment_id': commentId,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Like post comment
  static Future likePostComment(
    int commentId, {
    bool? isLiked,
  }) async {
    return await DioHelper.post(
      'community/posts/comments/$commentId/like',
      parameters: {
        'isLiked': isLiked == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Report post comment
  static Future reportPostComment(
    int commentId, {
    bool? reason,
  }) async {
    return await DioHelper.post(
      'community/posts/comments/$commentId/reports',
      parameters: {
        'reason': reason,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Delete post comment
  static Future deletePostComment(int commentId) async {
    return await DioHelper.delete(
      'community/posts/comments/$commentId',
      applyUserTypeInUrl: true,
    );
  }

  /// Edit post comment
  static Future editPostComment(
    int commentId, {
    required String comment,
  }) async {
    return await DioHelper.post(
      'community/posts/comments/$commentId',
      parameters: {
        'comment': comment,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Offers

  /// Create offer
  static Future createOffer({
    categoryId,
    required String content,
    required String expiresIn,
    required String salePercentage,
    String? advertisementUrl,
    Map? media,
  }) async {
    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      files: media,
      fromDataAttributeName: 'media',
      data: {
        'categoryId': categoryId,
        'content': content,
        'expiresIn': expiresIn,
        'salePercentage': salePercentage,
        'advertisementUrl': advertisementUrl,
      },
    );

    return await DioHelper.post(
      'community/offers',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Update offer
  static Future updateOffer(
    id, {
    required categoryId,
    required String content,
  }) async {
    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'categoryId': categoryId,
        'content': content,
      },
    );

    return await DioHelper.post(
      'community/offers/$id',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Get offers (pagination)
  static Future getOffers({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
    bool? isShowMyOffersOnly = false,
  }) async {
    return await DioHelper.get(
      'community/offers',
      limit: limit,
      page: page,
      parameters: {
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
        'isShowMyOffersOnly': (isShowMyOffersOnly != null
            ? (isShowMyOffersOnly == true ? 1 : 0)
            : null),
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get offer by id
  static Future getOfferById(id) async {
    return await DioHelper.get(
      'community/offers/$id',
      applyUserTypeInUrl: true,
    );
  }

  /// Get saved offers (pagination)
  static Future getSavedOffers({
    int? limit,
    int? page = 1,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await DioHelper.get(
      'community/offers/saved',
      limit: limit,
      page: page,
      parameters: {
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get offers search (pagination)
  static Future getOffersSearch({
    int? limit,
    int? page = 1,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    /// Handle data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'limit': limit,
        'page': page,
        'keyword': keyword,
        'categoryId': categoryId,
        'countryCode': countryCode,
        'cityId': cityId,
      },
    );

    return await DioHelper.post(
      'community/offers/search',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Get offers by advertiser id (pagination)
  static Future getOffersByAdvertiserId({
    required int id,
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'community/offers/advertisers/$id',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Get offers by customer id (pagination)
  static Future getOffersByCustomerId({
    required int id,
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'community/offers/interacted/customer/$id',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Like offer
  static Future likeOffer(
    int offerId, {
    bool? isLiked,
  }) async {
    return await DioHelper.post(
      'community/offers/$offerId/like',
      parameters: {
        'isLiked': isLiked == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Save offer
  static Future saveOffer(
    int offerId, {
    bool? isSaved,
  }) async {
    return await DioHelper.post(
      'community/offers/$offerId/save',
      parameters: {
        'isSaved': isSaved == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get notifications offer
  static Future getNotificationsOffer(
    int offerId, {
    bool? isSaved,
  }) async {
    return await DioHelper.post(
      'community/offers/$offerId/save',
      parameters: {
        'isSaved': isSaved == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Subscribe offer
  static Future subscribeOffer(
    int offerId, {
    bool? isSubscribed,
  }) async {
    return await DioHelper.post(
      'community/offers/$offerId/subscribe',
      parameters: {
        'isSaved': isSubscribed == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Report offers
  static Future reportOfferById(
    int offerId, {
    String? reason,
  }) async {
    return await DioHelper.post(
      'community/offers/$offerId/reports',
      applyUserTypeInUrl: true,
      parameters: {
        'reason': reason,
      },
    );
  }

  /// delete offers
  static Future deleteOffer(int offerId) async {
    return await DioHelper.delete(
      'community/offers/$offerId',
      applyUserTypeInUrl: true,
    );
  }

  /// Rate offer by id
  static Future rateOfferById({
    required id,
    required rate,
    comment,
  }) async {
    return await DioHelper.post(
      'community/offers/$id/rate',
      parameters: {
        'rate': rate,
        'comment': comment,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Offers Comments

  /// Get offer comments
  static Future getOfferComments(
    offerId, {
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'community/offers/$offerId/comments',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Add offer comments
  static Future addOfferComment(
    offerId, {
    required String comment,
  }) async {
    return await DioHelper.post(
      'community/offers/$offerId/comments',
      parameters: {
        'comment': comment,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Like offer comment
  static Future likeOfferComment(
    int commentId, {
    bool? isLiked,
  }) async {
    return await DioHelper.post(
      'community/offers/comments/$commentId/like',
      parameters: {
        'isLiked': isLiked == true ? 1 : 0,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Report offer comment
  static Future reportOfferComment(
    int commentId, {
    bool? reason,
  }) async {
    return await DioHelper.post(
      'community/offers/comments/$commentId/reports',
      parameters: {
        'reason': reason,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Delete offer comment
  static Future deleteOfferComment(int commentId) async {
    return await DioHelper.delete(
      'community/offers/comments/$commentId',
      applyUserTypeInUrl: true,
    );
  }

  /// Edit offer comment
  static Future editOfferComment(
    int commentId, {
    required String comment,
  }) async {
    return await DioHelper.post(
      'community/offers/comments/$commentId',
      parameters: {
        'comment': comment,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Proposals

  /// Create proposal
  static Future createProposal({
    required int advertiserId,
    required String content,
    Map? media,
  }) async {
    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      files: media,
      fromDataAttributeName: 'media',
      data: {
        'advertiserId': advertiserId,
        'content': content,
      },
    );

    return await DioHelper.post(
      'community/proposals',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Get proposals (pagination)
  static Future getProposals({
    int? limit,
    int? page = 1,
    bool? isSent = true,
    bool? isAnswered = true,
  }) async {
    return await DioHelper.get(
      'community/proposals',
      limit: limit,
      page: page,
      parameters: {
        'isSent': (isSent == true ? 1 : 0),
        'isAnswered': (isAnswered == true ? 1 : 0),
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get proposal
  static Future getProposalById(int id) async {
    return await DioHelper.get(
      'community/proposals/$id',
      applyUserTypeInUrl: true,
    );
  }

  /// Answer proposal
  static Future answerProposal(
    id, {
    required answer,
    required expiresIn,
  }) async {
    return await DioHelper.post(
      'community/proposals/$id/answer',
      parameters: {
        'answer': answer,
        'expiresIn': expiresIn,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Report proposal
  static Future reportProposalById(
    int id, {
    String? reason,
  }) async {
    return await DioHelper.post(
      'community/proposals/$id/reports',
      applyUserTypeInUrl: true,
      parameters: {
        'reason': reason,
      },
    );
  }

  /* ***************************************************************** */
  /* Chat */

  /// Get chats (pagination)
  static Future getChats({
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'chats',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Get or create chat
  static Future getOrCreateChat({
    required int toUserId,
    required String toUserType,
  }) async {
    return await DioHelper.post(
      'chats/add',
      parameters: {
        'toUserId': toUserId,
        'toUserType': toUserType,
      },
      applyUserTypeInUrl: true,
    );
  }

  /// Get chat by token
  static Future getChatByToken(token) async {
    return await DioHelper.get(
      'chats/$token',
      applyUserTypeInUrl: true,
    );
  }

  /// Get chat messages (pagination)
  static Future getChatMessages(
    String token, {
    int? limit,
    int? page = 1,
    bool? isReceived = true,
  }) async {
    return await DioHelper.get(
      'chats/$token/messages',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Add chat message
  static Future addChatMessage(
    token, {
    String? message,
    File? mediaFile,
    bool? isVoiceNote,
  }) async {
    /// Start show errors
    DioHelper.isAutoShowErrors = true;

    /// Handle media and data (FormData)
    FormData data = await DioHelper.dataToFormData(
      files: mediaFile,
      fromDataAttributeName: 'media',
      data: {
        'message': message,
        'isVoiceNote': isVoiceNote,
      },
    );

    return await DioHelper.post(
      'chats/$token/messages/send',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /* ***************************************************************** */

  /// Contact Us

  /// create contact us
  static Future createContactUs({
    required String type,
    required String name,
    required String mobile,
    required String whatsappMobile,
    String? email,
    required String message,
  }) async {
    return await DioHelper.post(
      'contact-us',
      parameters: {
        'type': type,
        'name': name,
        'mobile': mobile,
        'whatsappMobile': whatsappMobile,
        'email': email,
        'message': message,
      },
    );
  }

  /// ---------------------------------------------------------------------------
  /// Notifications

  /// Get notifications (pagination)
  static Future getNotifications({
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'notifications',
      limit: limit,
      page: page,
      applyUserTypeInUrl: true,
    );
  }

  /// Read all notifications
  static Future readAllNotifications() async {
    return await DioHelper.post(
      'notifications/read',
      applyUserTypeInUrl: true,
    );
  }

  /// Delete notification
  static Future deleteNotificationById(id) async {
    return await DioHelper.delete(
      'notifications/$id',
      applyUserTypeInUrl: true,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Packages

  /// Get packages
  static Future getPackages() async {
    return await DioHelper.get(
      'subscriptions/packages',
      applyUserTypeInUrl: true,
    );
  }

  /// Get user package
  static Future getUserPackage() async {
    return await DioHelper.get(
      'subscriptions/packages/user',
      applyUserTypeInUrl: true,
    );
  }

  /// Validate packages
  static Future validatePackage({
    productId,
    verificationData,
    deviceOS,
    transactionDate,
    purchaseID,
    status,
    source,
  }) async {
    /// Handle data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'productId': productId,
        'purchaseID': purchaseID,
        'verificationData': verificationData,
        'deviceOS': deviceOS,
        'transactionDate': transactionDate,
        'status': status,
        'source': source,
      },
    );

    return await DioHelper.post(
      'subscriptions/packages/validate',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// Validate packages
  static Future sendPackageIdentifier({
    productId,
    purchaseID,
    identifier,
    deviceOS,
    transactionDate,
    status,
    source,
  }) async {
    /// Handle data (FormData)
    FormData data = await DioHelper.dataToFormData(
      data: {
        'productId': productId,
        'purchaseID': purchaseID,
        'identifier': identifier,
        'deviceOS': deviceOS,
        'transactionDate': transactionDate,
        'status': status,
        'source': source,
      },
    );

    return await DioHelper.post(
      'subscriptions/packages/validate',
      data: data,
      applyUserTypeInUrl: true,
    );
  }

  /// ---------------------------------------------------------------------------
  /// Follow

  /// Get followers (pagination)
  static Future getFollowers({
    int? limit,
    int? page = 1,
    String? userType,
    int? userId,
  }) async {
    return await DioHelper.get(
      'users/followers',
      limit: limit,
      page: page,
      parameters: {
        'userType': userType,
        'userId': userId,
      },
    );
  }

  /// Get followed (pagination)
  static Future getFollowed({
    int? limit,
    int? page = 1,
    String? userType,
    int? userId,
  }) async {
    return await DioHelper.get(
      'users/followed',
      limit: limit,
      page: page,
      parameters: {
        'userType': userType,
        'userId': userId,
      },
    );
  }

  /// Get follow requests (pagination)
  static Future getFollowRequests({
    int? limit,
    int? page = 1,
  }) async {
    return await DioHelper.get(
      'users/follow/requests',
      limit: limit,
      page: page,
    );
  }

  /// Update follow request
  static Future updateFollowRequest(
    id, {
    required status,
  }) async {
    return await DioHelper.put(
      'users/follow/requests/$id',
      parameters: {
        'status': status,
      },
    );
  }

  ///change lan Notification
  static Future changeLanNotification(
       {
        required String lan,
      }) async {
    return await DioHelper.post(
      'language/change',
      parameters: {
        'language': lan,
      },
      applyUserTypeInUrl: true,
    ).then((value) {

    });
  }

  /// ---------------------------------------------------------------------------
}
