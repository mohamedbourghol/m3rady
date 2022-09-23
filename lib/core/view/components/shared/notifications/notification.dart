import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/notifications/notifications_controller.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:url_launcher/url_launcher.dart';




class WNotification extends StatefulWidget {




  var notification;

  GlobalKey<PaginationViewState> notificationsPaginationViewKey;
  WNotification({
    required this.notification,
    required this.notificationsPaginationViewKey
  });

  @override
  _WNotificationState createState() => _WNotificationState();
}

class _WNotificationState extends State<WNotification> {
  bool isShown = true;
  final NotificationsController notificationsController =
  Get.put(NotificationsController());
  @override
  Widget build(BuildContext context) {
    IconData notificationIcon = Icons.notifications;

    /// Set notification icon
    if (widget.notification.data?['type'] == 'posts') {
      notificationIcon = Icons.list_alt;
    } else if (widget.notification.data?['type'] == 'chats') {
      notificationIcon = Icons.message;
    } else if (widget.notification.data?['type'] == 'posts.comments') {
      notificationIcon = Icons.add_comment;
    } else if (widget.notification.data?['type'] == 'offers.comments') {
      notificationIcon = Icons.add_comment;
    } else if (widget.notification.data?['type'] == 'advertisers.rates') {
      notificationIcon = Icons.star_rate;
    } else if (widget.notification.data?['type'] == 'offers.rates') {
      notificationIcon = Icons.star_rate;
    } else if (widget.notification.data?['type'] == 'followings') {
      notificationIcon = Icons.person_add;
    } else if (widget.notification.data?['type'] == 'proposals') {
      notificationIcon = Icons.featured_play_list;
    } else if (widget.notification.data?['type'] == 'offers') {
      notificationIcon = Icons.sell_outlined;
    }

    return isShown? InkWell(
      onTap: () {
        // Handle redirection
        if (widget.notification.data?['type'] == 'chats' &&
            widget.notification.data?['chatToken'] != null) {
          Get.toNamed(
            '/chat',
            arguments: {
              'token': widget.notification.data?['chatToken'],
            },
          );
        } else if (widget.notification.data?['type'] == 'posts' &&
            widget.notification.data?['postId'] != null) {
          Get.toNamed(
            '/post',
            arguments: {
              'postId': widget.notification.data?['postId'],
            },
          );
        } else if (widget.notification.data?['type'] == 'posts.comments' &&
            widget.notification.data?['postId'] != null &&
            widget.notification.data?['commentId'] != null) {
          Get.toNamed(
            '/post',
            arguments: {
              'postId': widget.notification.data?['postId'],
              'commentId': widget.notification.data?['commentId'],
            },
          );
        } else if (widget.notification.data?['type'] == 'proposals' &&
            widget.notification.data?['proposalId'] != null) {
          Get.toNamed(
            '/proposal',
            arguments: {
              'proposalId': widget.notification.data?['proposalId'],
            },
          );
        } else if (widget.notification.data?['type'] == 'followings') {
          if (widget.notification.data?['status'] == 'approved') {
            Get.toNamed(
              '/profile/followers',
            );
          } else {
            Get.toNamed(
              '/profile/followers/requests',
            );
          }
        } else if (widget.notification.data?['type'] == 'offers') {
          Get.toNamed(
            '/offers',
            arguments: {
              'isShowMyOffersOnly': true,
            },
          );
        } else if (widget.notification.data?['type'] == 'offers.rates') {
          Get.toNamed(
            '/offers',
            arguments: {
              'isShowMyOffersOnly': true,
            },
          );
        } else if (widget.notification.data?['type'] == 'offers.comments') {
          Get.toNamed(
            '/offers',
            arguments: {
              'isShowMyOffersOnly': true,
              'offerId': widget.notification.data?['offerId'],
              'commentId': widget.notification.data?['commentId'],
            },
          );
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsetsDirectional.only(
          start: 12,
          end: 12,
          top: 10,
          bottom: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Stack(
              children: [
                // Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        12,
                      ),
                    ),
                    color: Colors.blue.shade100,
                  ),
                  child: Center(
                    child: Icon(
                      notificationIcon,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ),

                // Is read
                Visibility(
                  visible: widget.notification.isRead == false,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Notification
            Container(
              width: Get.width - 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: (Get.width - 140) / 1.3,
                          child: Text(
                            widget.notification.title ?? 'Notification'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                       SizedBox(height: 4,),
                        // Content
                        Text(
                          widget.notification.content,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        if(widget.notification.notifyLink!=null)
                        SizedBox(height: 4,),
                        if(widget.notification.notifyLink!=null)
                        InkWell(
                          onTap: () async {
                            await launch(widget.notification.notifyLink);
                          },
                          child: Text(
                            "Click to watch".tr,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Time
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 1,
                      maxWidth: (Get.width - 80) / 4.5,
                    ),
                    child: Text(
                      widget.notification.createdAt,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () async {
                    isShown=false;
                    setState(() {

                    });
                    await notificationsController
                        .deleteNotification(widget.notification);
                    try {
                      widget.notificationsPaginationViewKey.currentState!
                          .refresh()
                          .onError((error, stackTrace) {})
                          .catchError((e) {});
                    } catch (e) {}
                  }, icon: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    ):SizedBox();
  }
}
