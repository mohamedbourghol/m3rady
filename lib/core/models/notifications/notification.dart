import 'package:m3rady/core/utils/services/AppServices.dart';

class Notification {
  String id;
  String? title;
  String content;
  Map? data;
  bool isRead;
  String? createdAt;
  String? notifyLink;

  Notification({
    required this.id,
    this.title,
    required this.content,
    this.data,
    this.isRead = false,
    this.notifyLink,
    this.createdAt,
  });

  /// Factory
  factory Notification.fromJson(Map<String, dynamic> data) {
    return Notification(
      id: data['id'] as String,
      title: data['title'],
      notifyLink: data['notify_link'],
      content: data['content'] as String,
      data: data['data'],
      isRead: data['isRead'],
      createdAt: data['createdAt'],
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Notification.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get notifications (pagination)
  static Future getNotifications({
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var notifications = await AppServices.getNotifications(
      limit: limit,
      page: page,
    );

    if (notifications['status'] == true) {
      data['data'] = generateMapWithIdFromJson(notifications['data']);
      data['pagination'] = notifications['pagination'];
    }

    return data;
  }

  /// Read all notifications
  static Future readAllNotifications() async {
    return await AppServices.readAllNotifications();
  }

  /// Delete notification
  static Future deleteNotificationById(id) async {
    return await AppServices.deleteNotificationById(id);
  }
}
