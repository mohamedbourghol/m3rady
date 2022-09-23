import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:permission_handler/permission_handler.dart';
///import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsHelper {
  static final NotificationsHelper _notificationService =
      NotificationsHelper._internal();

  factory NotificationsHelper() {
    return _notificationService;
  }

  /*static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();*/

  NotificationsHelper._internal();

  /// Initialize
  static Future init() async {
    /*final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );*/
  }

  /// Request send message
  static void requestNotificationsPermission() async {
    if (GlobalVariables.isUserAuthenticated.value == true) {
      await Permission.notification.request();
    }
  }

  /// Select notification
  static Future onSelectNotification(String? payload) async {
    if (payload == 'goto:/notifications') {
      if (GlobalVariables.isUserAuthenticated.value == true) {
        if (Get.currentRoute != '/notifications') {
          Get.toNamed('/notifications');
        }
      }
    }
  }

  /// Show notification
  static Future<void> showNotification({
    int id = 1,
    String? title,
    required String body,
    int seconds = 1,
    payload = 'goto:/notifications',
  }) async {
    // Check title
    if (title == null) {
      title = 'New Notification'.tr;
    }

   /* await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(
        Duration(seconds: seconds),
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          'Main channel notifications',
          importance: Importance.max,
          priority: Priority.max,
          enableLights: true,
          enableVibration: true,
          icon: '@drawable/ic_notification',
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
    );*/
  }

  /// Set badge
  static Future<void> setBadge(int count) async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
        FlutterAppBadger.updateBadgeCount(count);
    }
  }


  /// Cancel notifications
  static Future<void> cancelAllNotifications() async {
    // Remove badge
    FlutterAppBadger.removeBadge();

    //await flutterLocalNotificationsPlugin.cancelAll();
  }
}
