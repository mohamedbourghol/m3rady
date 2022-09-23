import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/offers/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/offers/offers_controller.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/offers/comments/comment.dart';
import 'package:pagination_view/pagination_view.dart';

class WOfferCommentAction extends StatefulWidget {
  var offer;
  var commentId;

  WOfferCommentAction({
    required this.offer,
    this.commentId,
  });

  @override
  _WOfferCommentActionState createState() => _WOfferCommentActionState();
}

class _WOfferCommentActionState extends State<WOfferCommentAction> {
  /// Set offers controller
  OffersController offersController = Get.find<OffersController>();

  /// Set comments controller
  OffersCommentsController commentsController = Get.put(OffersCommentsController());

  /// Set offer comment form key
  GlobalKey<FormState> offerCommentFormKey = GlobalKey<FormState>();

  /// Set offer comment controller
  TextEditingController offerCommentController = TextEditingController();

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
    offerCommentController.text = offerCommentController.text.trim();

    /// Validate form
    if (offerCommentFormKey.currentState!.validate()) {
      /// Start loader
      isLoadingAddingComment.value = true;

      /// Add comment
      await commentsController.addOfferComment(
        widget.offer.id,
        comment: offerCommentController.text,
      );

      /// add to the statistics
      widget.offer.statistics['comments']++;

      /// update
      offersController.update();

      /// Clean comment
      offerCommentController.clear();

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
      comments = await commentsController.getOfferComments(
        widget.offer.id,
        page: commentsCurrentPage,
      );

      /// Set total comments count in the statistics
      if (widget.offer.statistics['comments'] <
          comments['pagination']?['meta']?['page']?['total']) {
        widget.offer.statistics['comments'] =
            comments['pagination']?['meta']?['page']?['total'];
      }

      /// Update offer
      offersController.update();

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
                      WOfferComment(
                    offer: widget.offer,
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
                visible: widget.offer.permissions['isAllowComment'] == true,
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
                            key: offerCommentFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: offerCommentController,
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
                        widget.offer.statistics['comments']) ??
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
