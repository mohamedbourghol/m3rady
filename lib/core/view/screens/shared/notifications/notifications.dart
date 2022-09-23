import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/notifications/notifications_controller.dart';
import 'package:m3rady/core/view/components/shared/notifications/notification.dart';

import 'package:pagination_view/pagination_view.dart';

class NotificationsScreen extends StatefulWidget {


  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with
    AutomaticKeepAliveClientMixin{
  final NotificationsController notificationsController =
  Get.put(NotificationsController());




  /// Notifications Pagination View
  ScrollController notificationsPaginationViewScrollController =
      ScrollController();

  GlobalKey<PaginationViewState> notificationsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int notificationsCurrentPage = 1;

  bool isNotificationsHasNextPage = true;

  /// Fetch notifications
  Future<List<dynamic>> fetchNotificationsByOffset(offset) async {
    List notificationsData = [];
    late Map notifications;

    /// Get notifications
    if (isNotificationsHasNextPage || offset == 0) {
      notificationsCurrentPage = offset == 0 ? 1 : notificationsCurrentPage + 1;

      notifications = await notificationsController.getNotifications(
        page: notificationsCurrentPage,
      );

      /// notifications
      if (notifications['data'].length > 0) {
        isNotificationsHasNextPage =
            notifications['pagination']['meta']['page']['isNext'] == true;

        notificationsData =
            notifications['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return notificationsData;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GetBuilder<NotificationsController>(
        builder: (controller) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0.5,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child:  Column(
            children: [
              /// Edges
              Container(
                padding: const EdgeInsetsDirectional.only(
                  start: 12,
                  end: 12,
                ),
                height: 12,
              ),

              Expanded(
                child: PaginationView(
                  key: notificationsPaginationViewKey,
                  scrollController:
                  notificationsPaginationViewScrollController,
                  itemBuilder:
                      (BuildContext context, notification, int index) {
                    return WNotification(
                      notification: notification,
                      notificationsPaginationViewKey: notificationsPaginationViewKey,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                        width: 8,
                        height: 8,
                      ),
                  pageFetch: fetchNotificationsByOffset,
                  pullToRefresh: true,
                  onError: (dynamic error) => Center(
                    child: Text('No Notifications.'.tr),
                  ),
                  onEmpty: Center(
                    child: Text('No Notifications.'.tr),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// Delete controllers
    Get.delete<NotificationsController>();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
