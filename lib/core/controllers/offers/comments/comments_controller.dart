import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/offers/comments/comment.dart';

class OffersCommentsController extends GetxController {
  GlobalKey<FormState> updateCommentFormKey = GlobalKey<FormState>();
  TextEditingController updateCommentController = TextEditingController();

  /// Get post comments (pagination)
  Future getOfferComments(
    int postId, {
    int? limit,
    int? page,
  }) async {
    return await OfferComment.getOfferComments(
      postId,
      limit: limit,
      page: page,
    );
  }

  /// Like/dislike comment
  void updateIsLikedByCommentId(id, isLiked) {
    /// set comment like
    likeComment(id, isLiked);

    /// Vibrate
   // HapticFeedback.lightImpact();

    update();
  }

  /// report comment
  Future reportOfferComment(id) async {
    /// Send request
    return await OfferComment.reportComment(id);
  }

  /// like comment
  Future likeComment(id, isLiked) async {
    /// Send request
    return await OfferComment.likeComment(id, isLiked);
  }

  /// delete comment
  Future deleteOfferComment(id) async {
    /// Send request
    return await OfferComment.deleteOfferComment(id);
  }

  /// edit comment
  Future editOfferComment(
    id, {
    required comment,
  }) async {
    /// Send request
    return await OfferComment.editOfferComment(
      id,
      comment: comment,
    );
  }

  /// add comment
  Future addOfferComment(
    postId, {
    required String comment,
  }) async {
    /// Send request
    var data = await OfferComment.addOfferComment(
      postId,
      comment: comment,
    );

    return data;
  }
}
