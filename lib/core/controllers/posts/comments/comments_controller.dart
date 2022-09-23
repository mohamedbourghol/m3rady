
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/posts/comments/comment.dart';

class CommentsController extends GetxController {
  GlobalKey<FormState> updateCommentFormKey = GlobalKey<FormState>();
  TextEditingController updateCommentController = TextEditingController();

  /// Get post comments (pagination)
  Future getPostComments(
    int postId, {
    int? limit,
    int? page,
  }) async {
    return await PostComment.getPostComments(
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
  Future reportPostComment(id) async {
    /// Send request
    return await PostComment.reportComment(id);
  }

  /// like comment
  Future likeComment(id, isLiked) async {
    /// Send request
    return await PostComment.likeComment(id, isLiked);
  }

  /// delete comment
  Future deletePostComment(id) async {
    /// Send request
    return await PostComment.deletePostComment(id);
  }

  /// edit comment
  Future editPostComment(
    id, {
    required comment,
  }) async {
    /// Send request
    return await PostComment.editPostComment(
      id,
      comment: comment,
    );
  }

  /// add comment
  ///
  /// add Reply when commentID==0
  Future addPostComment(
    postId, {
    required String comment,
        required int commentId,
  }) async {
    /// Send request
    var data = await PostComment.addPostComment(
      postId,
      comment: comment,
      commentId: commentId
    );

    return data;
  }


}
