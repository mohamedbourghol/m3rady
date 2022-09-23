import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/rates/rate.dart';
import 'package:m3rady/core/view/components/components.dart';

class RatesController extends GetxController {
  GlobalKey<FormState> rateFormKey = GlobalKey<FormState>();
  TextEditingController rateCommentController = TextEditingController();
  double? rateStars;

  /// Get rates by advertiser id (pagination)
  Future getRatesByAdvertiserId(
    id, {
    int? limit,
    int? page,
  }) async {
    return await Rate.getRatesByAdvertiserId(
      id,
      limit: limit,
      page: page,
    );
  }

  /// Rate advertiser by id
  Future rateAdvertiserById({
    required id,
    required rate,
    comment,
  }) async {
    /// Start loading
    MainLoader.set(true);

    var request = await Rate.rateAdvertiserById(
      id: id,
      rate: rate,
      comment: comment,
    );

    /// Stop loading
    MainLoader.set(false);

    if (request != false) {
      CToast(text: request['message']);
    }

    return request;
  }
}
