import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/helpers/notifications_helper.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

class FCM {
  static Future init() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      /// Get token
      await FirebaseMessaging.instance.getToken().then((token) async {
        await LocalStorage.set('fcmToken', token);

        /// On message
        FirebaseMessaging.onMessage.listen(firebaseMessagingOnMessageHandler);

        /// On background message
        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);

        /// When open message
        FirebaseMessaging.onMessageOpenedApp
            .listen(firebaseMessagingOpenAppHandler);
      });
    } catch (e) {
      if (config['isDebugMode']) print(e);
    }
  }

  static Future<void> firebaseMessagingOnMessageHandler(
      RemoteMessage message) async {
    /// show notification
    /*if (message.notification != null && message.notification!.body != null) {
      NotificationsHelper.showNotification(
        title: message.notification?.title,
        body: message.notification!.body!,
      );
    }*/
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Add to badge
    NotificationsHelper.setBadge(1);
  }

  static Future<void> firebaseMessagingOpenAppHandler(
      RemoteMessage message) async {
    if (GlobalVariables.isUserAuthenticated.value == true) {
      if (Get.currentRoute != '/notifications') {
        Get.toNamed('/notifications');
      }
    }
  }
}
