import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/models/posts/comments/comment.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/posts/comments/comment.dart';
import 'package:pagination_view/pagination_view.dart';

class WPostCommentAction extends StatefulWidget {
  final post;
  final commentId;

  WPostCommentAction({
    required this.post,
    this.commentId,
  });

  @override
  _WPostCommentActionState createState() => _WPostCommentActionState();
}

class _WPostCommentActionState extends State<WPostCommentAction> {
  /// Set posts controller
  PostsController postsController
  =  Get.put(PostsController());


  /// Set comments controller
  CommentsController commentsController   =
  Get.put(CommentsController());


  /// Set post comment form key
  GlobalKey<FormState> postCommentFormKey = GlobalKey<FormState>();

  /// Set post comment controller
  TextEditingController postCommentController = TextEditingController();

  /// Comments pagination view key
  GlobalKey<PaginationViewState> commentsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  PageController pageController=PageController();

  /// Set if loading comments
  var isLoadingAddingComment = false.obs;

ScrollController scrollController=ScrollController();
  List commentsData = [];
  @override
  void initState() {

    super.initState();


    late Map comments= widget.post.comments;

    commentsData =
        comments.entries.map((entry) => entry.value).toList();
    /// After loading
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        /// Open comments
        if (widget.commentId != 0) {
          openComments();
        }
      },
    );
  }

  /// Add comment
  Future<int> addComment() async {
    /// Trim comment
    postCommentController.text = postCommentController.text.trim();

    /// Validate form
    if (postCommentFormKey.currentState!.validate()) {


      /// Start loader
     // isLoadingAddingComment.value = true;
        String com=postCommentController.text;
        /// update
        postsController.update();

        /// Clean comment
        postCommentController.clear();

        /// add to the statistics
        widget.post.statistics['comments']++;



        /// Un focus
        Get.focusScope!.unfocus();
      /// Add comment
        var data=  await commentsController.addPostComment(
        widget.post.id,
        comment: com,
          commentId: 0
     );

       return data["data"]["id"] as int;
    }
    else
      return 0;
  }









  /// Open comments
  Future openComments() async {
    /// Show comments bottom sheet
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
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
                     child: ListView(
                       controller: scrollController,
                       reverse: true,
                       physics: BouncingScrollPhysics(),
                       children: [
                       ListView.separated(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemBuilder: (context, index) =>  WPostComment(
                           post: widget.post,
                           comment: commentsData[index],
                           delete: (){
                             commentsData.removeAt(index);
                             setState((){});
                           },
                         ),
                         itemCount: commentsData.length,
                         separatorBuilder: (BuildContext context, int index) =>
                             SizedBox(
                               width: 8,
                               height: 8,
                             ),

                       ),
                     ],
                     ),
                   ),
                CBr(),
                Visibility(
                  visible: widget.post.permissions['isAllowComment'] == true,
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
                                  onPressed: () async {

                                    commentsData.add(PostComment(
                                        id: 0,
                                        createdAt: 'الان',
                                        replies: [],
                                        content:  postCommentController.text,
                                        isLiked: false,
                                        owner: GlobalVariables.user,
                                        permissions: {
                                          "isAllowActions": true,
                                          "isAllowLike": true,
                                          "isAllowReport": false,
                                          "isAllowEdit": true,
                                          "isAllowDelete": true
                                        },
                                        statistics: {
                                          "likes": 0
                                        }
                                    ));

                                    setState(() {

                                    });

                                    await addComment().then((value) {
                                      if(value is int)
                                        {
                                          commentsData[commentsData.length-1].id=value;

                                        }
                                    });
                                    setState(() {

                                    });
                                  },
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
        );
      },

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
                        widget.post.statistics['comments']) ??
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
