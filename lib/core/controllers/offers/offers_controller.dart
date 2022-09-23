import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/offers/offer.dart';
import 'package:m3rady/core/view/components/components.dart';

class OffersController extends GetxController {
  GlobalKey<FormState> offerFormKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> offerUpdateFormKey = GlobalKey<FormState>();
  TextEditingController contentUpdateController = TextEditingController();
  TextEditingController advertisementUrlController = TextEditingController();
  TextEditingController salePercentageController = TextEditingController();
  TextEditingController expiresInController = TextEditingController();

  var offerAttachmentType = 'images'.obs;
  String? selectedCategoryId;
  String? selectedCategoryIdUpdate;
  double? rateStars;

  /// Set files
  Map<int, File?> images = {};
  Map<int, File?> videos = {};

  /// Set image with callback
  File? handleImageByIndexCallback({
    required int index,
    File? file,
    bool getCurrentFile = false,
  }) {
    /// Get current image
    if (getCurrentFile == true) {
      return images[index] ?? null;
    }

    if (file != null) {
      images[index] = file;
    } else {
      images.remove(index);
    }

    return file;
  }

  /// Set video with callback
  File? handleVideoByIndexCallback({
    required int index,
    File? file,
    bool getCurrentFile = false,
  }) {
    /// Get current image
    if (getCurrentFile == true) {
      return videos[index] ?? null;
    }

    if (file != null) {
      videos[index] = file;
    } else {
      videos.remove(index);
    }

    return file;
  }

  /// Update offer
  Future updateOffer(
    id, {
    required content,
    required categoryId,
  }) async {
    /// Create
    var request = await Offer.update(
      id,
      categoryId: selectedCategoryIdUpdate,
      content: contentUpdateController.text,
    );

    if (request != false) {
      CToast(text: request['message']);
    }

    update();

    return request;
  }

  /// Submit
  Future submitOfferCreateForm() async {
    /// Start loader
    MainLoader.set(true);

    /// Trim text
    contentController.text = contentController.text.trim();

    if (offerFormKey.currentState != null &&
        offerFormKey.currentState!.validate()) {
      /// Create
      var request = await Offer.create(
        categoryId: selectedCategoryId,
        content: contentController.text,
        advertisementUrl: advertisementUrlController.text,
        salePercentage: salePercentageController.text,
        expiresIn: expiresInController.text,
        media: (offerAttachmentType.value == 'images' ? images : videos),
      );

      /// if request created
      if (request != false) {
        /// Get user data to get allowed offers
        await Authentication.setAndGetUserData();

        /// Show success dialog
        CSentSuccessfullyDialog(
          text: request['message'],
          callback: () {
            Get.back();
          },
        );

        /// Clear data
        contentController.clear();
        advertisementUrlController.clear();
        salePercentageController.clear();
        expiresInController.clear();

        images = {};
        videos = {};
        offerAttachmentType.value = 'images';

        /// Render
        update();
      }
    }

    /// Stop loader
    MainLoader.set(false);
  }

  /// Get offers (pagination)
  Future getOffers({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
    bool? isShowMyOffersOnly = false,
  }) async {
    return await Offer.getOffers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
      isShowMyOffersOnly: isShowMyOffersOnly,
    );
  }

  /// Get saved offers (pagination)
  Future getSavedOffers({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await Offer.getSavedOffers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get offers search (pagination)
  Future getOffersSearch({
    int? limit,
    int? page,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await Offer.getOffersSearch(
      limit: limit,
      page: page,
      keyword: keyword,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get offers by advertiser id (pagination)
  Future getOffersByAdvertiserId({
    required int id,
    int? limit,
    int? page,
  }) async {
    return await Offer.getOffersByAdvertiserId(
      id: id,
      limit: limit,
      page: page,
    );
  }

  /// Get offers by customer id (pagination)
  Future getOffersByCustomerId({
    required int id,
    int? limit,
    int? page,
  }) async {
    return await Offer.getOffersByCustomerId(
      id: id,
      limit: limit,
      page: page,
    );
  }

  /// Like/dislike offer
  void updateIsLikedByOfferId(id, isLiked) {
    /// set offer like
    likeOffer(id, isLiked);

    /// Vibrate
   // HapticFeedback.lightImpact();

    update();
  }

  /// like offer
  Future likeOffer(id, isLiked) async {
    return await Offer.likeOffer(id, isLiked);
  }

  /// save offer
  Future saveOffer(id, isSaved) async {
    /// Send request
    var save = await Offer.saveOffer(id, isSaved);

    /// Show success dialog
    if (save != false) {
      /// Show success dialog
      CToast(
        text: save['message'],
      );
    }

    update();
  }

  /// Get offer by id
  Future getOfferById(id) async {
    /// Send request
    var offer = await Offer.getOfferById(id);

    if (offer != false) {
      return offer;
    }

    return false;
  }

  /// report offer
  Future reportOffer(id) async {
    /// Show dialog
    CConfirmDialog(
      content: 'Are you sure that you want to report this offer?'.tr,
      confirmText: 'Report'.tr,
      confirmCallback: () async {
        /// Send request
        var report = await Offer.reportOfferById(id);

        /// Show success dialog
        if (report != false) {
          /// Show success dialog
          CToast(
            text: report['message'],
          );
        }
      },
    );
  }

  /// subscribe offer
  Future subscribeOffer(id, isSubscribed) async {
    /// Send request
    var subscribe = await Offer.subscribeOffer(id, isSubscribed);

    /// Show success dialog
    if (subscribe != false) {
      /// Show success dialog
      CToast(
        text: subscribe['message'],
      );
    }

    return subscribe;
  }

  /// hide offers
  Future hideOffersByAdvertiserId(id, isHidden) async {
    /// Send request
    var hide = await Offer.hideOffersByAdvertiserId(
      id,
      isHidden: isHidden,
    );

    return hide;
  }

  /// delete offers
  Future deleteOffer(id) async {
    /// Send request
    return await Offer.deleteOffer(id);
  }

  /// Rate advertiser by id
  Future rateOffer({
    required id,
    required rate,
    comment,
  }) async {

    var request = await Offer.rateOffer(
      id: id,
      rate: rate,
      comment: comment,
    );

    if (request != false) {
      CToast(text: request['message']);
    }

    return request;
  }
}
