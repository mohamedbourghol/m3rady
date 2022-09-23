import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class OfferComment {
  int id;
  String content;
  Map? statistics;
  Map? permissions;
  User owner;
  String? createdAt;
  bool isLiked;

  OfferComment({
    required this.id,
    required this.content,
    required this.owner,
    required this.isLiked,
    required this.statistics,
    required this.permissions,
    required this.createdAt,
  });

  /// Factory
  factory OfferComment.fromJson(Map<String, dynamic> data) {
    return OfferComment(
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
        var entry = OfferComment.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get offer comments (pagination)
  static Future getOfferComments(
    int offerId, {
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var offers = await AppServices.getOfferComments(
      offerId,
      limit: limit,
      page: page,
    );

    if (offers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(offers['data']);
      data['pagination'] = offers['pagination'];
    }

    return data;
  }

  /// add comment
  static Future addOfferComment(
    offerId, {
    required String comment,
  }) async {
    var data = await AppServices.addOfferComment(
      offerId,
      comment: comment,
    );

    if (data['status'] == true) {
      return {
        'message': data['message'],
        'data': data['data'],
      };
    }

    return false;
  }

  /// like comment
  static Future likeComment(id, isLiked) async {
    var like = await AppServices.likeOfferComment(
      id,
      isLiked: isLiked,
    );

    if (like['status'] == true) {
      return true;
    }

    return false;
  }

  /// delete comment
  static Future deleteOfferComment(id) async {
    var delete = await AppServices.deleteOfferComment(id);

    if (delete['status'] == true) {
      return {
        'message': delete['message'],
        'data': delete['data'],
      };
    }

    return false;
  }

  /// report comment
  static Future reportComment(id) async {
    var report = await AppServices.reportOfferComment(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }

  /// edit comment
  static Future editOfferComment(
    id, {
    required comment,
  }) async {
    var edit = await AppServices.editOfferComment(
      id,
      comment: comment,
    );

    if (edit['status'] == true) {
      return {
        'message': edit['message'],
        'data': edit['data'],
      };
    }

    return false;
  }
}
