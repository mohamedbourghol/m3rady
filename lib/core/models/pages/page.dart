import 'package:m3rady/core/utils/services/AppServices.dart';

class Page {
  int id;
  String title;
  String content;

  Page({
    required this.id,
    required this.title,
    required this.content,
  });

  /// Factory
  factory Page.fromJson(Map<String, dynamic> data) {
    return Page(
      id: data['id'] as int,
      title: data['title'] as String,
      content: data['content'] as String,
    );
  }

  /// Get data
  static Future getPageBySlug(String slug) async {
    var page = await AppServices.getPageBySlug(slug);
    if (page['status'] == true) {
      return Page.fromJson(page['data']);
    }
  }
}
