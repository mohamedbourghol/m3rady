import 'package:m3rady/core/models/users/user.dart';


class ReplyModel {
  int id;
  String content;
  Map? statistics;
  Map? permissions;
  User owner;
  String? createdAt;
  bool isLiked;


  ReplyModel({
    required this.id,
    required this.content,
    required this.owner,
    required this.isLiked,
    required this.statistics,
    required this.permissions,
    required this.createdAt,

  });

  /// Factory
  factory ReplyModel.fromJson(Map<String, dynamic> data) {
    return ReplyModel(
      id: data['id'] as int,
      content: data['content'] as String,
      owner: User.fromJson(data['owner']),
      isLiked: data['isLiked'] == true,
      statistics: {
        'likes': data['statistics']?['likes'] ?? 0,
      },
      permissions: {
        'isAllowActions': data['permissions']?['isAllowActions'] ?? false,
        'isAllowLike': data['permissions']?['isAllowLike'] ?? false,
        'isAllowReport': data['permissions']?['isAllowReport'] ?? false,
        'isAllowEdit': data['permissions']?['isAllowEdit'] ?? false,
        'isAllowDelete': data['permissions']?['isAllowDelete'] ?? false,
      },
      createdAt: data['createdAt'] as String,

    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = ReplyModel.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }




}
