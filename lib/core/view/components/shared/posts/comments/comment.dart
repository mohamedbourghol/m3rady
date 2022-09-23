import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/models/posts/comments/comment.dart';
import 'package:m3rady/core/models/posts/comments/replyModel.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';




class WPostComment extends StatefulWidget {
  PostComment comment;
  VoidCallback delete;
  var post;


  WPostComment({Key? key,
    required this.comment,
    required this.post,
    required this.delete
  }) : super(key: key);

  @override
  _WPostCommentState createState() => _WPostCommentState();
}

class _WPostCommentState extends State<WPostComment> {

  /// Set posts controller
  PostsController postsController = Get.find<PostsController>();

  /// Set comments controller
  CommentsController commentsController = Get.put(CommentsController());


  TextEditingController replyController=TextEditingController();


  /// Like comment
  Future likeComment() async {
    /// Set statistics
    widget.comment.isLiked = !widget.comment.isLiked;
    if (widget.comment.isLiked) {
      widget.comment.statistics?['likes']++;
    } else {
      widget.comment.statistics?['likes']--;
    }

    /// Send request
    commentsController.updateIsLikedByCommentId(widget.comment.id, widget.comment.isLiked);
  }

  /// Like comment
  Future likeReply(int index) async {
    /// Set statistics
    widget.comment.replies![index].isLiked = !widget.comment.replies![index].isLiked;
    if (widget.comment.replies![index].isLiked) {
      widget.comment.replies![index].statistics?['likes']++;
    } else {
      widget.comment.replies![index].statistics?['likes']--;
    }

    /// Send request
    commentsController.updateIsLikedByCommentId(
        widget.comment.replies![index].id,
        widget.comment.replies![index].isLiked);
  }

  /// Show edit comment dialog
  void showEditComment() {
    /// Set current comment
    commentsController.updateCommentController.text = widget.comment.content;

    /// Show dialog
    CConfirmDialog(
      confirmText: 'Edit'.tr,
      title: 'Edit Comment'.tr,
      contentWidget: Column(
        children: [
          Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: commentsController.updateCommentFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CTextFormField(
                  controller: commentsController.updateCommentController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 7,
                  maxLength: 250,
                  labelText: 'Edit Comment'.tr,
                  onEditingComplete: () {
                    Get.focusScope?.nextFocus();
                  },
                  isRequired: true,
                ),
              ],
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        if (commentsController.updateCommentFormKey.currentState!.validate()) {
          /// Close sheet
          Get.back();

          /// Update
          widget.comment.content = commentsController.updateCommentController.text;
          commentsController.update();

          var edit = await commentsController.editPostComment(
            widget.comment.id,
            comment: widget.comment.content,
          );

          if (edit != false) {
            /// Show toast
            //CToast(text: edit['message']);
          }
        }
      },
      autoClose: false,
    );
  }

  /// Show edit comment dialog
  void showEditReply(int index) {
    /// Set current comment
    commentsController.updateCommentController.text = widget.comment.replies![index].content;

    /// Show dialog
    CConfirmDialog(
      confirmText: 'Edit'.tr,
      title: 'Edit Reply'.tr,
      contentWidget: Column(
        children: [
          Form(
            key: commentsController.updateCommentFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CTextFormField(
                  controller: commentsController.updateCommentController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 7,
                  maxLength: 250,
                  labelText: 'Edit Comment'.tr,
                  onEditingComplete: () {
                    Get.focusScope?.nextFocus();
                  },
                  isRequired: true,
                ),
              ],
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        if (commentsController.updateCommentFormKey.currentState!.validate()) {
          /// Close sheet
          Get.back();

          /// Update
          widget.comment.replies![index].content = commentsController.updateCommentController.text;
          commentsController.update();

          var edit = await commentsController.editPostComment(
          widget.comment.replies![index].id,
            comment: widget.comment.replies![index].content,
          );

          if (edit != false) {
            /// Show toast
            //CToast(text: edit['message']);
          }
        }
      },
      autoClose: false,
    );
  }

  /// Show Reply dialog
  Future<dynamic> showReply(BuildContext context) async => CConfirmDialog(
    confirmText: 'reply'.tr,
    title: 'add reply'.tr,
    contentWidget: Column(
      children: [
        Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CTextFormField(
                controller: replyController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 7,
                maxLength: 250,
                labelText: 'Add Reply'.tr,
                onEditingComplete: () {
                  Get.focusScope?.nextFocus();
                },
                isRequired: true,
              ),
            ],
          ),
        ),
      ],
    ),
    confirmTextColor: Colors.green,
    confirmCallback: () async {
      if (replyController.text.trim()!='') {
        /// Close sheet


        Navigator.pop(context,true);





      }
    },
    autoClose: false,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentsController>(
      builder: (_) => SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image
                GestureDetector(
                  onTap: () {
                    /// Goto user profile
                    if (!widget.comment.owner.isSelf!) {
                      /// Redirect to advertiser profile
                      if (widget.comment.owner.type == 'advertiser') {
                        Get.offAndToNamed('/advertiser/profile', arguments: {
                          'id': widget.comment.owner.id,
                        });
                      } else if (widget.comment.owner.type == 'customer') {
                        Get.offAndToNamed('/customer/profile', arguments: {
                          'id': widget.comment.owner.id,
                        });
                      }
                    } else {
                      Get.toNamed('/profile/me');
                    }
                  },
                  child: WUserImage(
                    widget.comment.owner.imageUrl ?? '',
                    isElite: widget.comment.owner.isElite!,
                    radius: 24,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xffF1F2F6),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Color(0xffF1F2F6),
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Name
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 1,
                                  maxWidth: Get.width / 1.4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    /// Goto user profile
                                    if (!widget.comment.owner.isSelf!) {
                                      /// Redirect to advertiser profile
                                      if (widget.comment.owner.type == 'advertiser') {
                                        Get.offAndToNamed('/advertiser/profile',
                                            arguments: {
                                              'id': widget.comment.owner.id,
                                            });
                                      } else if (widget.comment.owner.type ==
                                          'customer') {
                                        Get.offAndToNamed('/customer/profile',
                                            arguments: {
                                              'id': widget.comment.owner.id,
                                            });
                                      }
                                    } else {
                                      Get.toNamed('/profile/me');
                                    }
                                  },
                                  child: Text(
                                    widget.comment.owner.fullName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 1,
                              maxWidth: Get.width / 1.4,
                            ),
                            child: Text(
                              widget.comment.content,
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Like
                          Row(
                            children: [
                              InkWell(
                                child: Icon(
                                  (  widget.comment.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_outline),
                                  color: (  widget.comment.isLiked
                                      ? Colors.red
                                      : Colors.grey),
                                  size: 20,
                                ),
                                onTap:
                                (widget.comment.permissions!['isAllowLike'] == false
                                    ? null
                                    : () => likeComment()),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                child: Text(
                                  'like'.trArgs(
                                    [
                                      widget.comment.statistics?['likes'].toString() ??
                                          '0',
                                    ],
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap:
                                (widget.comment.permissions!['isAllowLike'] == false
                                    ? null
                                    : () => likeComment()),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 6,
                          ),

                          Visibility(
                            visible: widget.comment.permissions!['isAllowEdit'] !=
                                false ||
                                widget.comment.permissions!['isAllowReport'] != false ||
                                widget.comment.permissions!['isAllowDelete'] != false,
                            child: Text(
                              '-'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: InkWell(
                              child: Text(
                                'reply'.tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () async{
                                await  showReply(context).then((value) async {
                                  print(value);
                                  if(value is bool)
                                  {
                                    print('hr');
                                    widget.comment.replies!.add(ReplyModel(
                                        id: 0,
                                        createdAt: 'الان',
                                        content:  replyController.text,
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
                                    setState((){});
                                    var reply = await commentsController.addPostComment(
                                        widget.post.id,
                                        comment:     replyController.text,
                                        commentId:  widget.comment.id
                                    );
                                    replyController.clear();
                                    widget.comment.replies![ widget.comment.replies!.length-1].id=reply["data"]["id"];
                                  }
                                } );
                              },
                            ),
                          ),

                          /// Edit
                          (widget.comment.permissions!['isAllowEdit'] == false
                              ? SizedBox()
                              : Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: InkWell(
                              child: Text(
                                'Edit'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () => showEditComment(),
                            ),
                          )),

                          /// Delete
                          (widget.comment.permissions!['isAllowDelete'] == false
                              ? SizedBox()
                              : Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: InkWell(
                              child: Text(
                                'Delete'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                CConfirmDialog(
                                  content:
                                  "Are you sure that you want to delete this comment"
                                      .tr,
                                  confirmText: 'Delete'.tr,
                                  confirmCallback: () async {
                                    /// add to the statistics

                                    var delete = await commentsController
                                        .deletePostComment(widget.comment.id);
                                    widget.post.statistics['comments']--;
                                    widget.delete();

                                    if (delete != false) {
                                      CToast(text: delete['message']);


                                      postsController.update();


                                    }
                                  },
                                );
                              },
                            ),
                          )),
                          (widget.comment.permissions!['isAllowReport'] == false
                              ? SizedBox()
                              : Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: InkWell(
                              child: Text(
                                'Report'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                CConfirmDialog(
                                  content:
                                  "Are you sure that you want to report this comment?"
                                      .tr,
                                  confirmText: 'Report'.tr,
                                  confirmCallback: () async {
                                    var report = await commentsController
                                        .reportPostComment(widget.comment.id);

                                    if (report != false) {
                                      CToast(text: report['message']);

                                      /// update
                                      commentsController.update();
                                    }
                                  },
                                );
                              },
                            ),
                          )),

                          /// Date
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            widget.comment.createdAt ?? 'Now'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image
                    GestureDetector(
                      onTap: () {
                        /// Goto user profile
                        if (!widget.comment.replies![index].owner.isSelf!) {
                          /// Redirect to advertiser profile
                          if (widget.comment.replies![index].owner.type == 'advertiser') {
                            Get.offAndToNamed('/advertiser/profile', arguments: {
                              'id': widget.comment.replies![index].owner.id,
                            });
                          } else if (widget.comment.replies![index].owner.type == 'customer') {
                            Get.offAndToNamed('/customer/profile', arguments: {
                              'id': widget.comment.replies![index].owner.id,
                            });
                          }
                        } else {
                          Get.toNamed('/profile/me');
                        }
                      },
                      child: WUserImage(
                        widget.comment.replies![index].owner.imageUrl ?? '',
                        isElite: widget.comment.replies![index].owner.isElite!,
                        radius: 24,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xffF1F2F6),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(14),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Color(0xffF1F2F6),
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /// Name
                              Row(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 1,
                                      maxWidth: Get.width / 1.4,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        /// Goto user profile
                                        if (!widget.comment.replies![index].owner.isSelf!) {
                                          /// Redirect to advertiser profile
                                          if (widget.comment.replies![index].owner.type == 'advertiser') {
                                            Get.offAndToNamed('/advertiser/profile',
                                                arguments: {
                                                  'id': widget.comment.replies![index].owner.id,
                                                });
                                          } else if (widget.comment.replies![index].owner.type ==
                                              'customer') {
                                            Get.offAndToNamed('/customer/profile',
                                                arguments: {
                                                  'id': widget.comment.replies![index].owner.id,
                                                });
                                          }
                                        } else {
                                          Get.toNamed('/profile/me');
                                        }
                                      },
                                      child: Text(
                                        widget.comment.replies![index].owner.fullName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 1,
                                  maxWidth: Get.width / 1.4,
                                ),
                                child: Text(
                                  widget.comment.replies![index].content,
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /// Like
                              Row(
                                children: [
                                  InkWell(
                                    child: Icon(
                                      (widget.comment.replies![index].isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_outline),
                                      color: (widget.comment.replies![index].isLiked
                                          ? Colors.red
                                          : Colors.grey),
                                      size: 20,
                                    ),
                                    onTap:
                                    (widget.comment.replies![index].permissions!['isAllowLike'] == false
                                        ? null
                                        : () => likeReply(index)),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  InkWell(
                                    child: Text(
                                      'like'.trArgs(
                                        [
                                          widget.comment.replies![index].statistics?['likes'].toString() ??
                                              '0',
                                        ],
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    onTap:
                                    (widget.comment.replies![index].permissions!['isAllowLike'] == false
                                        ? null
                                        : () => likeReply(index)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 6,
                              ),

                              Visibility(
                                visible: widget.comment.replies![index].permissions!['isAllowEdit'] !=
                                    false ||
                                    widget.comment.replies![index].permissions!['isAllowReport'] != false ||
                                    widget.comment.replies![index].permissions!['isAllowDelete'] != false,
                                child: Text(
                                  '-'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 3,
                                ),
                                child: InkWell(
                                  child: Text(
                                    'reply'.tr,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () async{

                                    await  showReply(context).then((value) async {
                                      print(value);
                                      if(value is bool)
                                      {
                                        print('hr');

                                        widget.comment.replies!.add(ReplyModel(
                                            id: 0,
                                            createdAt: 'الان',
                                            content:  replyController.text,
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
                                        var reply = await commentsController.addPostComment(
                                            widget.post.id,
                                            comment: replyController.text,
                                            commentId:  widget.comment.id
                                        );
                                        widget.comment.replies![ widget.comment.replies!.length-1].id=reply["data"]["id"];
                                        replyController.clear();
                                      }
                                    } );
                                  },
                                ),
                              ),

                              /// Edit
                              (widget.comment.replies![index].permissions!['isAllowEdit'] == false
                                  ? SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 3,
                                ),
                                child: InkWell(
                                  child: Text(
                                    'Edit'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () => showEditReply(index),
                                ),
                              )),

                              /// Delete
                              (widget.comment.replies![index].permissions!['isAllowDelete'] == false
                                  ? SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 3,
                                ),
                                child: InkWell(
                                  child: Text(
                                    'Delete'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    CConfirmDialog(
                                      content:
                                      "Are you sure that you want to delete this comment"
                                          .tr,
                                      confirmText: 'Delete'.tr,
                                      confirmCallback: () async {

                                        var delete = await commentsController
                                            .deletePostComment(widget.comment.replies![index].id);
                                        widget.comment.replies!.removeAt(index);

                                        /// add to the statistics
                                        setState(() {

                                        });
                                        if (delete != false) {
                                          CToast(text: delete['message']);

                                        }
                                      },
                                    );
                                  },
                                ),
                              )),
                              (widget.comment.replies![index].permissions!['isAllowReport'] == false
                                  ? SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 3,
                                ),
                                child: InkWell(
                                  child: Text(
                                    'Report'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    CConfirmDialog(
                                      content:
                                      "Are you sure that you want to report this comment?"
                                          .tr,
                                      confirmText: 'Report'.tr,
                                      confirmCallback: () async {
                                        var report = await commentsController
                                            .reportPostComment(widget.comment.replies![index].id);
                                        if (report != false) {
                                          CToast(text: report['message']);

                                          /// update
                                          commentsController.update();
                                        }
                                      },
                                    );
                                  },
                                ),
                              )),

                              /// Date
                              SizedBox(
                                width: 3,
                              ),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                widget.comment.replies![index].createdAt ?? 'Now'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              itemCount: widget.comment.replies!.length,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(
                    width: 8,
                    height: 8,
                  ),

            ),


          ],
        ),
      ),
    );
  }

}
