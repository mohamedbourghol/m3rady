import 'package:get/get.dart';
import 'package:m3rady/core/helpers/notifications_helper.dart';
import 'package:m3rady/core/models/notifications/notification.dart';

class NotificationsController extends GetxController {
  @override
  void onReady() {
    super.onReady();

    /// Read all messages
    NotificationsHelper.cancelAllNotifications();
  }

  /// Update notification count
  Future updateNotificationsCount(int count) async {
    return await NotificationsHelper.setBadge(count);
  }

  /// Get notifications (pagination)
  Future getNotifications({
    limit,
    page,
  }) async {
    return await Notification.getNotifications(
      limit: limit,
      page: page,
    );
  }

  /// Read all notifications
  Future readAllNotifications() async {
    await Notification.readAllNotifications();
  }

  /// Delete notification
  Future deleteNotification(notification) async {
    await Notification.deleteNotificationById(notification.id);
  }
}
