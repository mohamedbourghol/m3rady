import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/controllers/system/languages/languages_controller.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisersController extends GetxController {
  int maximumEliteCompaniesPerTime = (Get.width / 100).round();

  int eliteCompaniesPerTimerInterval =
      ((Get.width / 100).round() * 3);

  var currentEliteCompanies = [].obs;

   List<User> eliteAdvertisementList=[];
  /// Fetch elite advertisers data
  int eliteAdvertisersCurrentPage = 1;
  bool isEliteAdvertisersHasNextPage = true;

  /// Fetch new elite advertisers
  Future<List<User>> fetchNewEliteCompanies() async {
    late Map advertisers;
    /// Get advertisers
    advertisers = await getEliteAdvertisers(
      page: eliteAdvertisersCurrentPage,
      limit: 30,
    );

    ///  handle advertisers
    if (advertisers['data'].length > 0) {

      isEliteAdvertisersHasNextPage =
          advertisers['pagination']['meta']['page']['isNext'] == true;

      currentEliteCompanies.value =
          advertisers['data'].entries.map((entry) => entry.value).toList();
       for(var tt in currentEliteCompanies)
         {
           eliteAdvertisementList.add(tt);
         }

      print("advertisers['data']");
      print(eliteAdvertisementList.length);
      print("advertisers['data']");
       return eliteAdvertisementList;
    }
      return [];
  }

  /// Fetch new elite advertisers
  Future fetchModals(context) async {
  var res= await AppServices.getModals();
  final box = GetStorage();
  int oldShow=box.read('showModal')??0;
  try{
    if(res["data"]["data"]['id']>oldShow)
    {
       LanguageController appLanguage = Get.find<LanguageController>();
      box.write('showModal',res["data"]["data"]['id']);
       if (appLanguage.userLocale != 'ar') {
         AwesomeDialog(
           context: context,
           dialogType: DialogType.NO_HEADER,
           animType: AnimType.BOTTOMSLIDE,
           title: res["data"]["data"]['title_en']??'',
           desc: res["data"]["data"]['body_en']??'',
           btnCancelOnPress: () {

           },
           btnOkOnPress: () {
             if(res["data"]["data"]['link']!=null)
               launch(res["data"]["data"]['link']);
           },
           btnOkText: 'move',
           btnCancelText: 'close',
           btnOkColor: Color(0xff1271c6),

         )..show();
       }
       else
         {
           AwesomeDialog(
             context: context,
             dialogType: DialogType.NO_HEADER,
             animType: AnimType.BOTTOMSLIDE,
             title: res["data"]["data"]['title_ar']??'',
             desc: res["data"]["data"]['body_ar']??'',
             btnCancelOnPress: () {

             },
             btnOkOnPress: () {
               if(res["data"]["data"]['link']!=null)
                 launch(res["data"]["data"]['link']);
             },
             btnOkText: 'انتقال',
             btnCancelText: 'اغلاق',
             btnOkColor: Color(0xff1271c6),

           )..show();
         }
    }
  }
catch(e){}

  }


  Future<void> _showNotification(
      {required String title, required String details, required String url}) async {

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
            launch(payload);
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
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title,
        details ,
        platformChannelSpecifics,
        payload: url,
    );
  }
  /// Get advertiser
  Future getAdvertiser(id) async {
    return await User.getAdvertiser(id);
  }

  /// Follow advertiser
  Future toggleFollowAdvertiser(id, isFollow) async {
    return await User.toggleFollowAdvertiser(id, isFollow);
  }

  /// Get elite advertisers (pagination)
  Future getEliteAdvertisers({
    limit,
    page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await User.getEliteAdvertisers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get elite advertisers search (pagination)
  Future getAdvertisersSearch({
    limit,
    page,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await User.getAdvertisersSearch(
      limit: limit,
      page: page,
      keyword: keyword,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }

  /// Get advertisers (pagination)
  Future getAdvertisers({
    limit,
    page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    return await User.getAdvertisers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );
  }
}
