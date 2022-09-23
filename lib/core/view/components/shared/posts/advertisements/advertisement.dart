import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/media/media.dart';
import 'package:m3rady/core/view/components/shared/posts/advertisements/comments/comment_action.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:m3rady/core/view/widgets/photo_viewer/network_dialog.dart';
import 'package:m3rady/core/view/widgets/text/expandable_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class WAdvertisement extends StatelessWidget {
  var advertisement;
  var commentId;

  WAdvertisement({
    required this.advertisement,
    this.commentId,
  });

  /// Set post parameters
  bool isPostVisible = true;
  bool isActionsLoading = false;

  /// Set posts controller
  final PostsController postsController = Get.put(PostsController());

  /// Set comments controller
  final CommentsController commentsController = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsController>(
      builder: (controller) => Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: GestureDetector(
                    onTap: () async {
                      if (advertisement.image != null &&
                          advertisement.image != '') {
                        await dialogShowImages(
                            context: context,
                            ur: advertisement.image,
                      );

                      }
                    },
                    child: WUserImage(
                      advertisement.image,
                      radius: 25,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name
                    Container(
                      width: Get.width / 1.3,
                      child: Text(
                        advertisement.name ?? 'M3rady'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        /// Type
                        Text(
                          'Advertisement'.tr,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),

                        /// Break
                        Visibility(
                          visible: advertisement.advertiserUrl != null,
                          child: Text(
                            ' - ',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),

                        /// Url
                        Visibility(
                          visible: advertisement.advertiserUrl != null,
                          child: InkWell(
                            onTap: () async {
                              if (await canLaunch(
                                  advertisement.advertiserUrl)) {
                                await launch(advertisement.advertiserUrl);
                              }
                            },
                            child: Text(
                              'Go to Advertisement Link'.tr,
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            /// Content text
            Column(
              children: [
                /// Content text
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 12,
                    end: 12,
                  ),
                  child: Container(
                    width: Get.width,
                    child: ExpandableText(
                      advertisement.content,
                      trimLines: 2,
                    ),
                  ),
                ),

                SizedBox(
                  height: 6,
                ),

                /// Media with Views
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    /// Media
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: WMedia(
                        mediaList: advertisement.media,
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
                            /*Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),*/
                            Text(
                              'view'.trArgs(
                                [
                                  FilterHelper.formatNumbers(
                                          advertisement.statistics['views']) ??
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

                /// Post actions
                Container(
                  //width: Get.width / 1.3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(15),
                          ),*/
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
                        InkWell(
                          child: Row(
                            children: [
                              Icon(
                                (advertisement.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_outline),
                                color: (advertisement.isLiked
                                    ? Colors.red
                                    : Colors.grey),
                                size: 25,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'like'.trArgs(
                                  [
                                    FilterHelper.formatNumbers(advertisement
                                            .statistics['likes']) ??
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
                          onTap:
                              (advertisement.permissions['isAllowLike'] == false
                                  ? null
                                  : () {
                                      advertisement.isLiked =
                                          !advertisement.isLiked;
                                      if (advertisement.isLiked) {
                                        advertisement.statistics['likes']++;
                                      } else {
                                        advertisement.statistics['likes']--;
                                      }
                                      controller.updateIsLikedByPostId(
                                        advertisement.postId,
                                        advertisement.isLiked,
                                      );
                                    }),
                        ),

                        /// Comments
                        WAdvertisementCommentAction(
                          advertisement: advertisement,
                          commentId: commentId,
                        ),

                        /// Share
                        InkWell(
                          onTap: (advertisement.permissions['isAllowShare'] ==
                                  false
                              ? null
                              : () {
                                  Share.share(
                                    '${advertisement.websiteUrl}',
                                    subject: advertisement.name ?? 'M3rady'.tr,
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
    );
  }
}
