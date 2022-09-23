import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/offers/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/offers/offers_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

class WOfferComment extends StatelessWidget {
  var comment;
  var offer;

  WOfferComment({
    required this.comment,
    required this.offer,
  });

  /// Set offers controller
  OffersController offersController = Get.find<OffersController>();

  /// Set comments controller
  OffersCommentsController commentsController = Get.put(OffersCommentsController());

  /// Set is visible
  bool isVisible = true;

  /// Like comment
  Future likeComment() async {
    /// Set statistics
    comment?.isLiked = !comment?.isLiked;
    if (comment?.isLiked) {
      comment?.statistics?['likes']++;
    } else {
      comment?.statistics?['likes']--;
    }

    /// Send request
    commentsController.updateIsLikedByCommentId(comment.id, comment?.isLiked);
  }

  /// Show edit comment dialog
  void showEditComment() {
    /// Set current comment
    commentsController.updateCommentController.text = comment.content;

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
                  maxLines: 4,
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
          comment.content = commentsController.updateCommentController.text;
          commentsController.update();

          var edit = await commentsController.editOfferComment(
            comment.id,
            comment: comment.content,
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OffersCommentsController>(
      builder: (_) => Visibility(
        visible: isVisible,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              GestureDetector(
                onTap: () {
                  /// Goto user profile
                  if (!comment.owner.isSelf) {
                    /// Redirect to advertiser profile
                    if (comment.owner.type == 'advertiser') {
                      Get.offAndToNamed('/advertiser/profile', arguments: {
                        'id': comment.owner.id,
                      });
                    } else if (comment.owner.type == 'customer') {
                      Get.offAndToNamed('/customer/profile', arguments: {
                        'id': comment.owner.id,
                      });
                    }
                  } else {
                    Get.toNamed('/profile/me');
                  }
                },
                child: WUserImage(
                  comment?.owner?.imageUrl ?? '',
                  isElite: comment?.owner?.isElite,
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
                                  if (!comment.owner.isSelf) {
                                    /// Redirect to advertiser profile
                                    if (comment.owner.type == 'advertiser') {
                                      Get.offAndToNamed('/advertiser/profile',
                                          arguments: {
                                            'id': comment.owner.id,
                                          });
                                    } else if (comment.owner.type ==
                                        'customer') {
                                      Get.offAndToNamed('/customer/profile',
                                          arguments: {
                                            'id': comment.owner.id,
                                          });
                                    }
                                  } else {
                                    Get.toNamed('/profile/me');
                                  }
                                },
                                child: Text(
                                  comment?.owner?.fullName,
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
                            comment?.content,
                            maxLines: 4,
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
                                (comment?.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                                color: (comment?.isLiked
                                    ? Colors.red
                                    : Colors.grey),
                                size: 20,
                              ),
                              onTap:
                                  (comment.permissions['isAllowLike'] == false
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
                                    comment?.statistics?['likes'].toString() ??
                                        '0',
                                  ],
                                ),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              onTap:
                                  (comment.permissions['isAllowLike'] == false
                                      ? null
                                      : () => likeComment()),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 6,
                        ),

                        Visibility(
                          visible: comment.permissions['isAllowEdit'] !=
                                  false ||
                              comment.permissions['isAllowReport'] != false ||
                              comment.permissions['isAllowDelete'] != false,
                          child: Text(
                            '-'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        /// Edit
                        (comment.permissions['isAllowEdit'] == false
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
                        (comment.permissions['isAllowDelete'] == false
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
                                          "Are you sure that you want to delete this comment?"
                                              .tr,
                                      confirmText: 'Delete'.tr,
                                      confirmCallback: () async {
                                        var delete = await commentsController
                                            .deleteOfferComment(comment.id);

                                        if (delete != false) {
                                          CToast(text: delete['message']);

                                          /// add to the statistics
                                          offer.statistics['comments']--;
                                          offersController.update();

                                          /// Hide
                                          isVisible = false;
                                          commentsController.update();
                                        }
                                      },
                                    );
                                  },
                                ),
                              )),
                        (comment.permissions['isAllowReport'] == false
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
                                            .reportOfferComment(comment.id);

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
                          comment?.createdAt ?? 'Now'.tr,
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
      ),
    );
  }
}
