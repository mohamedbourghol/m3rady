import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/posts/advertisements/comments/comment.dart';
import 'package:pagination_view/pagination_view.dart';

class WAdvertisementCommentAction extends StatefulWidget {
  var advertisement;
  var commentId;

  WAdvertisementCommentAction({
    required this.advertisement,
    this.commentId,
  });

  @override
  _WAdvertisementCommentActionState createState() => _WAdvertisementCommentActionState();
}

class _WAdvertisementCommentActionState extends State<WAdvertisementCommentAction> {
  /// Set posts controller
  PostsController postsController = Get.find<PostsController>();

  /// Set comments controller
  CommentsController commentsController = Get.put(CommentsController());

  /// Set post comment form key
  GlobalKey<FormState> postCommentFormKey = GlobalKey<FormState>();

  /// Set post comment controller
  TextEditingController postCommentController = TextEditingController();

  /// Comments pagination view key
  GlobalKey<PaginationViewState> commentsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  /// Set if loading comments
  var isLoadingAddingComment = false.obs;

  /// Fetch comments data
  int commentsCurrentPage = 1;

  bool isCommentsHasNextPage = true;

  @override
  void initState() {
    super.initState();

    /// After loading
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        /// Open comments
        if (widget.commentId != null) {
          openComments();
        }
      },
    );
  }

  /// Add comment
  Future addComment() async {
    /// Trim comment
    postCommentController.text = postCommentController.text.trim();

    /// Validate form
    if (postCommentFormKey.currentState!.validate()) {
      /// Start loader
      isLoadingAddingComment.value = true;

      /// Add comment
      await commentsController.addPostComment(
        widget.advertisement.postId,
        comment: postCommentController.text,
        commentId: 0
      );

      /// add to the statistics
      widget.advertisement.statistics['comments']++;

      /// update
      postsController.update();

      /// Clean comment
      postCommentController.clear();

      /// Un focus
      Get.focusScope!.unfocus();

      /// Stop loader
      isLoadingAddingComment.value = false;

      /// Refresh comments
      commentsPaginationViewKey.currentState?.refresh();
    }
  }

  /// Fetch comments
  Future<List<dynamic>> fetchCommentsByOffset(offset) async {
    List commentsData = [];
    late Map comments;

    /// Get comments
    if (isCommentsHasNextPage || offset == 0) {
      commentsCurrentPage = offset == 0 ? 1 : commentsCurrentPage + 1;
      comments = await commentsController.getPostComments(
        widget.advertisement.postId,
        page: commentsCurrentPage,
      );

      /// Set total comments count in the statistics
      if (widget.advertisement.statistics['comments'] <
          comments['pagination']?['meta']?['page']?['total']) {
        widget.advertisement.statistics['comments'] =
            comments['pagination']?['meta']?['page']?['total'];
      }

      /// Update post
      postsController.update();

      ///  comments
      if (comments['data'].length > 0) {
        isCommentsHasNextPage =
            comments['pagination']['meta']['page']['isNext'] == true;

        commentsData =
            comments['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return commentsData;
  }

  /// Open comments
  Future openComments() async {
    /// Show comments bottom sheet
    Get.bottomSheet(
      GestureDetector(
        onTap: () {
          /// Unfocus
          Get.focusScope?.unfocus();
        },
        child: Container(
          height: Get.height / 1.2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: CBottomSheetHead(),
              ),
              Expanded(
                child: PaginationView(
                  key: commentsPaginationViewKey,
                  itemBuilder: (BuildContext context, comment, int index) =>
                      WAdvertisementComment(
                        advertisement: widget.advertisement,
                    comment: comment,
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    width: 8,
                    height: 8,
                  ),
                  pageFetch: fetchCommentsByOffset,
                  pullToRefresh: true,
                  onError: (dynamic error) => Center(
                    child: Text('No comments.'.tr),
                  ),
                  onEmpty: Center(
                    child: Text('No comments.'.tr),
                  ),
                  bottomLoader: Center(
                    /// optional
                    child: LoadingBouncingLine.circle(),
                  ),
                  initialLoader: Center(
                    /// optional
                    child: LoadingBouncingLine.circle(),
                  ),
                ),
              ),
              CBr(),
              Visibility(
                visible: widget.advertisement.permissions['isAllowComment'] == true,
                child: Obx(
                  () => (isLoadingAddingComment.value == true
                      ? Center(
                          child: LoadingBouncingLine.circle(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 24,
                            left: 16,
                            right: 16,
                          ),
                          child: Form(
                            key: postCommentFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: postCommentController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 4,
                                  maxLength: 250,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write your comment...'.tr,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xffF1F2F6),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xffF1F2F6),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xffF1F2F6),
                                        width: 1,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () async => await addComment(),
                                      icon: Icon(
                                        Icons.send,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xffF1F2F6),
                                    contentPadding: const EdgeInsetsDirectional.only(
                                      start: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    /// Trim value
                                    value = value?.trim();

                                    if (value == null || value.isEmpty) {
                                      return 'This field is required'.tr;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      enableDrag: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => openComments(),
      child: Row(
        children: [
          Icon(
            Icons.textsms_outlined,
            color: Colors.grey,
            size: 25,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            'comment'.trArgs(
              [
                FilterHelper.formatNumbers(
                        widget.advertisement.statistics['comments']) ??
                    '0',
              ],
            ),
            style: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
