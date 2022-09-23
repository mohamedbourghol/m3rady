import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/models/posts/like/likes.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/follow/follow_button.dart';
import 'package:m3rady/core/view/components/shared/media/media.dart';
import 'package:m3rady/core/view/components/shared/posts/advertisements/advertisement.dart';
import 'package:m3rady/core/view/components/shared/posts/comments/comment_action.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:m3rady/core/view/widgets/text/expandable_text.dart';
import 'package:share/share.dart';
import 'likes/likes_view.dart';






class WPost extends StatefulWidget {

  var post;
  var commentId;
   WPost({Key? key,required this.commentId,required this.post}) : super(key: key);

  @override
  _WPostState createState() => _WPostState();
}

class _WPostState extends State<WPost> {
  /// Set posts controller
  final PostsController postsController =
  Get.put(PostsController());


  /// Set comments controller
  final CommentsController commentsController =
    Get.put(CommentsController());


  /// Set post parameters
  bool isPostVisible = true;

  bool isActionsLoading = false;

  @override
  void initState() {
    super.initState();

    /// Set globally
    if ((GlobalVariables.hiddenCommunity
        .contains('advertiser.${widget.post.owner.id}') ||
        GlobalVariables.hiddenCommunity
            .contains('post.${widget.post.id}')) &&
        Get.currentRoute != "/advertiser/profile") {
      isPostVisible = false;
    }
  }

  /// Show post form
  void showEditUsernameForm() {
    /// Set category id
    postsController.selectedCategoryIdUpdate = (widget.post.categoryId != null
        ? widget.post.categoryId.toString()
        : null);

    /// Set content
    postsController.contentUpdateController.text = widget.post.content;

    CConfirmDialog(
      confirmText: 'Edit Post'.tr,
      title: 'Edit Post'.tr,
      contentWidget: Column(
        children: [
          Form(
            key: postsController.postUpdateFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CSelectFormField(
                  value: postsController.selectedCategoryIdUpdate,
                  isRequired: true,
                  disabledHint: Text(
                    'Loading...'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  labelText: 'Category'.tr,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Icon(Icons.category),
                  ),
                  items: [
                    ...GlobalVariables.user.interestedCategories != null &&
                        GlobalVariables.user.interestedCategories.length > 0
                        ? GlobalVariables.user.interestedCategories.entries
                        .map(
                          (entries) => DropdownMenuItem<String>(
                        value: entries.value.id.toString(),
                        child: Text(
                          entries.value.name.toString(),
                        ),
                      ),
                    )
                        .toList()
                        : []
                  ],
                  onChanged: (id) {
                    postsController.selectedCategoryIdUpdate = id.toString();
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                CTextFormField(
                  controller: postsController.contentUpdateController,
                  keyboardType: TextInputType.multiline,
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: 8,
                    end: 8,
                    top: 12,
                  ),
                  maxLength: 1500,
                  minLines: 4,
                  hintText: 'Post Content'.tr,
                  labelText: 'Post Content'.tr,
                  isRequired: true,
                ),
              ],
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        /// Trim text
        postsController.contentUpdateController.text =
            postsController.contentUpdateController.text.trim();

        /// Validate
        if (postsController.postUpdateFormKey.currentState != null &&
            postsController.postUpdateFormKey.currentState!.validate()) {
          /// Set content
          widget.post.content = postsController.contentUpdateController.text;

          /// Set category id
          widget.post.categoryId =
              int.parse(postsController.selectedCategoryIdUpdate!);

          /// Update
          postsController.update();

          /// Back
          Get.back();

          /// Update post
          await postsController.updatePost(
            widget.post.id,
            content: postsController.contentUpdateController.text,
            categoryId: postsController.selectedCategoryIdUpdate,
          );
        }
      },
      autoClose: false,
    );
  }

  @override
  Widget build(context) {
    return GetBuilder<PostsController>(builder: (controller) {
      /// Check if advertisement
      if (widget.post.isAdvertisement == true) {
        return WAdvertisement(
          advertisement: widget.post,
        );
      }

      return Visibility(
        visible: isPostVisible,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.5,
                  )
                ],
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: GestureDetector(
                              onTap: () {
                                /// Goto user profile
                                if (!widget.post.owner.isSelf) {
                                  Get.toNamed('/advertiser/profile',
                                      arguments: {
                                        'id': widget.post.owner.id,
                                      });
                                } else {
                                  Get.toNamed('/profile/me');
                                }
                              },
                              child: WUserImage(
                                widget.post.owner.imageUrl,
                                isElite: widget.post.owner.isElite == true,
                                radius: 30,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Company name
                              GestureDetector(
                                onTap: () {
                                  /// Goto user profile
                                  if (!widget.post.owner.isSelf) {
                                    Get.toNamed('/advertiser/profile',
                                        arguments: {
                                          'id': widget.post.owner.id,
                                        });
                                  } else {
                                    Get.toNamed('/profile/me');
                                  }
                                },
                                child: Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 1,
                                        maxWidth: Get.width / 1.7,
                                      ),
                                      child: Text(
                                        widget.post.owner.fullName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade400

                                        ),
                                      ),
                                    ),

                                    /// Follow
                                    FollowButton(
                                      user: widget.post.owner,
                                      dense: true,
                                      isHideUnFollowInDense: true,
                                    ),
                                  ],
                                ),
                              ),

                              /// Location, Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "${widget.post.owner.country} - ${widget.post.owner.city}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
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
                                    width: 5,
                                  ),
                                  Text(
                                    (widget.post.createdAt != ''
                                        ? widget.post.createdAt
                                        : 'Now'.tr),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// More
                      !widget.post.permissions['isAllowActions']
                          ? SizedBox()
                          : IconButton(
                        icon: (isActionsLoading == false
                            ? Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        )
                            : Container(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            color: Colors.black12,
                            strokeWidth: 2,
                          ),
                        )),
                        onPressed: isActionsLoading == true
                            ? () {}
                            : () async {
                          /// Start loading
                          isActionsLoading = true;
                          controller.update();
                          var updatedPost = await controller
                              .getPostById(widget.post.id);

                          /// Stop loading
                          isActionsLoading = false;
                          controller.update();

                          if (updatedPost != false) {
                            widget.post = updatedPost;
                          }

                          Get.bottomSheet(
                            Container(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    CBottomSheetHead(),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    /// Save post
                                    (!(widget.post.permissions[
                                    'isAllowSave'] ==
                                        true &&
                                        widget.post.isSaved ==
                                            false)
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Save Post'.tr),
                                      subtitle: Text(
                                        'Save post to get back to it anytime.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(Icons
                                          .bookmark_add_outlined),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close bottom sheet
                                        Get.back();

                                        widget.post.isSaved =
                                        !widget
                                            .post.isSaved;

                                        /// Report post
                                        await controller
                                            .savePost(
                                          widget.post.id,
                                          widget.post.isSaved,
                                        );
                                      },
                                    )),

                                    /// UnSave post
                                    (!(widget.post.permissions[
                                    'isAllowSave'] ==
                                        true &&
                                        widget.post.isSaved ==
                                            true)
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Unsave Post'.tr),
                                      subtitle: Text(
                                        'Remove this post from the saved list.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(Icons
                                          .bookmark_border),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close bottom sheet
                                        Get.back();

                                        widget.post.isSaved =
                                        !widget
                                            .post.isSaved;

                                        /// Save post
                                        await controller
                                            .savePost(
                                          widget.post.id,
                                          widget.post.isSaved,
                                        );

                                        /// Hide post
                                        if (Get.currentRoute ==
                                            '/posts/saved' &&
                                            widget.post
                                                .isSaved ==
                                                false) {
                                          isPostVisible =
                                          false;

                                          controller.update();
                                        }
                                      },
                                    )),

                                    /// Get Notifications
                                    (!(widget.post.permissions[
                                    'isAllowGetNotifications'] ==
                                        true &&
                                        widget.post
                                            .isSubscribed ==
                                            false)
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Get Notifications'
                                              .tr),
                                      subtitle: Text(
                                        'Get notifications about the new comments.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(Icons
                                          .notifications_outlined),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close sheet
                                        Get.back();

                                        /// Subscribe post
                                        await controller
                                            .subscribePost(
                                            widget
                                                .post.id,
                                            true);
                                      },
                                    )),

                                    /// Stop Notifications
                                    (!(widget.post.permissions[
                                    'isAllowGetNotifications'] ==
                                        true &&
                                        widget.post
                                            .isSubscribed ==
                                            true)
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Stop Notifications'
                                              .tr),
                                      subtitle: Text(
                                        'Stop notifications about the new comments.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(Icons
                                          .notifications_off_outlined),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close sheet
                                        Get.back();

                                        /// Subscribe post
                                        await controller
                                            .subscribePost(
                                            widget
                                                .post.id,
                                            false);
                                      },
                                    )),

                                    /// Hide Post
                                    (!(widget.post.permissions[
                                    'isAllowHideCompanyPosts'] ==
                                        true &&
                                        widget.post.isHidden ==
                                            false)
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Hide Post'.tr),
                                      subtitle: Text(
                                        'Hide any post from this user.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading:
                                      Icon(Icons.block),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close sheet
                                        Get.back();

                                        /// Show dialog
                                        CConfirmDialog(
                                          content:
                                          'Are you sure that you want to hide this post? This action will hide all the posts from this user.'
                                              .tr,
                                          confirmText:
                                          'Hide Post'.tr,
                                          confirmCallback:
                                              () async {
                                            /// Hide post
                                            var hide = await controller
                                                .hidePostsByAdvertiserId(
                                                widget
                                                    .post
                                                    .owner
                                                    .id,
                                                true);

                                            if (hide !=
                                                false) {
                                              /// Hide post
                                              if (Get.currentRoute !=
                                                  '/advertiser/profile') {
                                                isPostVisible =
                                                false;

                                                controller
                                                    .update();
                                              }

                                              /// Show success dialog
                                              CToast(
                                                text: hide[
                                                'message'],
                                              );
                                            }
                                          },
                                        );
                                      },
                                    )),

                                    /// Show Post
                                    (!(widget.post.permissions[
                                    'isAllowHideCompanyPosts'] ==
                                        true &&
                                        widget.post.isHidden ==
                                            true)
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Show Post'.tr),
                                      subtitle: Text(
                                        'Show any post from this user.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(Icons
                                          .visibility_outlined),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close sheet
                                        Get.back();

                                        /// Show post
                                        var show =
                                        await controller
                                            .hidePostsByAdvertiserId(
                                            widget
                                                .post
                                                .owner
                                                .id,
                                            false);

                                        if (show != false) {
                                          /// Show success dialog
                                          CToast(
                                            text: show[
                                            'message'],
                                          );
                                        }
                                      },
                                    )),

                                    /// Report Post
                                    (widget.post.permissions[
                                    'isAllowReport'] ==
                                        false
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Report Post'.tr),
                                      subtitle: Text(
                                        'Report this post.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading: Icon(Icons
                                          .report_problem_outlined),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close bottom sheet
                                        Get.back();

                                        /// Report post
                                        await controller
                                            .reportPost(widget
                                            .post.id);
                                      },
                                    )),

                                    /// Edit Post
                                    (widget.post.permissions[
                                    'isAllowEdit'] ==
                                        false
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Edit Post'.tr),
                                      subtitle: Text(
                                        'Edit this post.'.tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading:
                                      Icon(Icons.edit),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close bottom sheet
                                        Get.back();

                                        /// Edit post
                                        showEditUsernameForm();
                                      },
                                    )),

                                    /// Delete Post
                                    (widget.post.permissions[
                                    'isAllowDelete'] ==
                                        false
                                        ? SizedBox()
                                        : ListTile(
                                      title: Text(
                                          'Delete Post'.tr),
                                      subtitle: Text(
                                        'Delete this post.'
                                            .tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      leading:
                                      Icon(Icons.delete),
                                      minLeadingWidth: 0,
                                      enabled: true,
                                      selected: false,
                                      dense: true,
                                      onTap: () async {
                                        /// Close bottom sheet
                                        Get.back();

                                        /// Show dialog
                                        CConfirmDialog(
                                          content:
                                          'Are you sure that you want to delete this post?'
                                              .tr,
                                          confirmText:
                                          'Delete Post'
                                              .tr,
                                          confirmCallback:
                                              () async {
                                            /// Hide post
                                            var delete =
                                            await controller
                                                .deletePost(widget
                                                .post
                                                .id);

                                            /*if (delete !=
                                                                  false) {*/

                                            /// Hide post
                                            isPostVisible =
                                            false;

                                            /// Set globally
                                            GlobalVariables
                                                .hiddenCommunity
                                                .add(
                                                'post.${widget.post.id}');

                                            controller
                                                .update();

                                            /// Show success dialog
                                            CToast(
                                              text: delete[
                                              'message'],
                                            );

                                            ///}
                                          },
                                        );
                                      },
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  /// Content text
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 12,
                      end: 12,
                    ),
                    child: Container(
                      width: Get.width,
                      child: ExpandableText(
                        widget.post.content,
                        trimLines: 2,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 6,
                  ),

                  Column(
                    children: [
                      /// Media with Views
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          /// Media
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: WMedia(
                              mediaList: widget.post.media,
                            ),
                          ),

                          /// Visits
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              width: 85,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'view'.trArgs(
                                      [
                                        FilterHelper.formatNumbers(widget
                                            .post.statistics['views']) ??
                                            '0',
                                      ],
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      CBr(),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 24,
                            end: 24,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Likes
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (widget.post
                                        .permissions['isAllowLike'] ==
                                        false
                                        ? null
                                        : () {
                                      widget.post.isLiked =
                                      !widget.post.isLiked;
                                      if (widget.post.isLiked) {
                                        widget
                                            .post.statistics['likes']++;
                                        widget.post.likesUsers.add(LikesUsers(
                                          imageUrl:  GlobalVariables.user.imageUrl,
                                          id:  GlobalVariables.user.id,
                                          name: GlobalVariables.user.name,
                                          bio: GlobalVariables.user.bio,
                                          countryCode: GlobalVariables.user.countryCode,
                                          username: GlobalVariables.user.username,
                                        ));
                                        setState(() {

                                        });
                                      } else {
                                        widget
                                            .post.statistics['likes']--;
                                        widget.post.likesUsers.removeAt( widget.post.likesUsers.length-1);
                                        setState(() {

                                        });
                                      }
                                      controller.updateIsLikedByPostId(
                                        widget.post.id,
                                        widget.post.isLiked,
                                      );
                                    }),
                                    child: Icon(
                                      (widget.post.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_outline),
                                      color: (widget.post.isLiked
                                          ? Colors.red
                                          : Colors.grey),
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LikesView(
                                          likesModel: widget.post.likesUsers,
                                        )),
                                      );
                                    },
                                    child: Text(
                                      widget
                                          .post
                                          .statistics['likes'].toString()+' '+"Liked people".tr,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// Comments
                              WPostCommentAction(
                                post: widget.post,
                                commentId: widget.commentId,
                              ),

                              /// Share
                              InkWell(
                                onTap: (widget
                                    .post.permissions['isAllowShare'] ==
                                    false
                                    ? null
                                    : () {
                                  Share.share(
                                    '${widget.post.websiteUrl}',
                                    subject: widget.post.owner.fullName,
                                  );
                                }),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.reply_outlined,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    Text(
                                      'Share'.tr,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

