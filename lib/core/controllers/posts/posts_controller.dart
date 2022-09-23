import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/posts/advertisements/advertisement.dart';
import 'package:m3rady/core/models/posts/post.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:rxdart/subjects.dart';


class PostsController extends GetxController {
  GlobalKey<FormState> postFormKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> postUpdateFormKey = GlobalKey<FormState>();
  TextEditingController contentUpdateController = TextEditingController();
  var postAttachmentType = 'images'.obs;
  String? selectedCategoryId;
  String? selectedCategoryIdUpdate;

  /// Set files
  Map<int, File?> images = {};
  Map<int, File?> videos = {};

  /// Set image with callback
  File? handleImageByIndexCallback({
    required int index,
    File? file,
    bool getCurrentFile = false,
  }) {
    /// Get current image
    if (getCurrentFile == true) {
      return images[index] ?? null;
    }

    if (file != null) {
      images[index] = file;
    } else {
      images.remove(index);
    }

    return file;
  }

  /// Set video with callback
  File? handleVideoByIndexCallback({
    required int index,
    File? file,
    bool getCurrentFile = false,
  }) {
    /// Get current image
    if (getCurrentFile == true) {
      return videos[index] ?? null;
    }

    if (file != null) {
      videos[index] = file;
    } else {
      videos.remove(index);
    }

    return file;
  }

  /// Update post
  Future updatePost(
    id, {
    required content,
    required categoryId,
  }) async {
    /// Create
    var request = await Post.update(
      id,
      categoryId: selectedCategoryIdUpdate,
      content: contentUpdateController.text,
    );

    if (request != false) {
      CToast(text: request['message']);
    }

    update();

    return request;
  }

  Future<void> _showNotification() async {

    String? selectedNotificationPayload;
    // ignore: close_sinks
    final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails!.payload;

    }
    // ignore: close_sinks
    final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notification');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });


    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          selectedNotificationPayload = payload;
          selectNotificationSubject.add(payload);
        });

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(threadIdentifier: 'thread_id');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics,iOS:iOSPlatformChannelSpecifics );
    await flutterLocalNotificationsPlugin.show(
        0, 'Upload complete'.tr, 'Please refresh the home page to see your post'.tr, platformChannelSpecifics,
        payload: 'item x');
  }

  /// Submit
  Future submitPostCreateForm() async {
    /// Start loader
    MainLoader.set(false);

    /// Trim text
    contentController.text = contentController.text.trim();



    if (postFormKey.currentState != null &&
        postFormKey.currentState!.validate()) {
      CSentSuccessfullyDialog(
        text: 'Publishing...'.tr,
        callback: () {
          Get.back();
        },
      );

      /// Create
      var request = await Post.create(
        categoryId: selectedCategoryId,
        content: contentController.text,
        media: (postAttachmentType.value == 'images' ? images : videos),
      );

      /// if request created
      if (request != false) {
        /// Get user data to get allowed posts
        await Authentication.setAndGetUserData();

        /// Show success dialog
        _showNotification();

        /// Clear data
        contentController.clear();
        images = {};
        videos = {};
        postAttachmentType.value = 'images';

        /// Render
        update();
      }
    }

    /// Stop loader
    MainLoader.set(false);
  }

  /// Get posts (pagination)
  Future getPostsAds({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
    isRandom = true,
  }) async {
    return await PostAdvertisement.getPostsAds(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
      isRandom: true,
    );
  }

  /// Get posts (pagination)
  Future getPosts({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await Post.getPosts(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get saved posts (pagination)
  Future getSavedPosts({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await Post.getSavedPosts(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get posts search (pagination)
  Future getPostsSearch({
    int? limit,
    int? page,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await Post.getPostsSearch(
      limit: limit,
      page: page,
      keyword: keyword,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get posts by advertiser id (pagination)
  Future getPostsByAdvertiserId({
    required int id,
    int? limit,
    int? page,
  }) async {
    return await Post.getPostsByAdvertiserId(
      id: id,
      limit: limit,
      page: page,
    );
  }

  /// Get posts by customer id (pagination)
  Future getPostsByCustomerId({
    required int id,
    int? limit,
    int? page,
  }) async {
    return await Post.getPostsByCustomerId(
      id: id,
      limit: limit,
      page: page,
    );
  }

  /// Like/dislike post
  void updateIsLikedByPostId(id, isLiked) {
    /// set post like
    likePost(id, isLiked);

    /// Vibrate
   // HapticFeedback.lightImpact();

    update();
  }

  /// like post
  Future likePost(id, isLiked) async {
    return await Post.likePost(id, isLiked);
  }

  /// save post
  Future savePost(id, isSaved) async {
    /// Send request
    var save = await Post.savePost(id, isSaved);

    /// Show success dialog
    if (save != false) {
      /// Show success dialog
      CToast(
        text: save['message'],
      );
    }

    update();
  }

  /// Get post by id
  Future getPostById(id) async {
    /// Send request
    var post = await Post.getPostById(id);

    if (post != false) {
      return post;
    }

    return false;
  }

  /// report post
  Future reportPost(id) async {
    /// Show dialog
    CConfirmDialog(
      content: 'Are you sure that you want to report this post?'.tr,
      confirmText: 'Report'.tr,
      confirmCallback: () async {
        /// Send request
        var report = await Post.reportPostById(id);

        /// Show success dialog
        if (report != false) {
          /// Show success dialog
          CToast(
            text: report['message'],
          );
        }
      },
    );
  }

  /// subscribe post
  Future subscribePost(id, isSubscribed) async {
    /// Send request
    var subscribe = await Post.subscribePost(id, isSubscribed);

    /// Show success dialog
    if (subscribe != false) {
      /// Show success dialog
      CToast(
        text: subscribe['message'],
      );
    }

    return subscribe;
  }

  /// hide posts
  Future hidePostsByAdvertiserId(id, isHidden) async {
    /// Send request
    var hide = await Post.hidePostsByAdvertiserId(
      id,
      isHidden: isHidden,
    );

    /// Set globally
    if (isHidden == true) {
      GlobalVariables.hiddenCommunity.add('advertiser.${id}');
    } else {
      GlobalVariables.hiddenCommunity.remove('advertiser.${id}');
    }

    return hide;
  }

  /// delete posts
  Future deletePost(id) async {
    /// Send request
    return await Post.deletePost(id);
  }
}


class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}