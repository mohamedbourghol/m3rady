import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'replyModel.dart';

class PostComment {
  int id;
  String content;
  Map? statistics;
  Map? permissions;
  List<ReplyModel>? replies;
  User owner;
  String? createdAt;
  bool isLiked;


  PostComment({
    required this.id,
    required this.content,
    required this.owner,
    required this.isLiked,
    required this.statistics,
    required this.permissions,
    required this.createdAt,
    required this.replies
  });

  /// Factory
  factory PostComment.fromJson(Map<String, dynamic> data) {
    return PostComment(
      id: data['id'] as int,
      content: data['content'] as String,
      owner: User.fromJson(data['owner']),
      replies:List<ReplyModel>.from(data["replies"].map((x) => ReplyModel.fromJson(x))),
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
        var entry = PostComment.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get post comments (pagination)
  static Future getPostComments(
    int postId, {
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getPostComments(
      postId,
      limit: limit,
      page: page,
    );

    if (posts['status'] == true) {
      data['data'] = generateMapWithIdFromJson(posts['data']);
      data['pagination'] = posts['pagination'];
    }

    return data;
  }

  /// add comment
  static Future addPostComment(
    postId, {
    required String comment,
        required int commentId,
  }) async {
    var data = await AppServices.addPostComment(
      postId,
      comment: comment,
      commentId: commentId
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
    var like = await AppServices.likePostComment(
      id,
      isLiked: isLiked,
    );

    if (like['status'] == true) {
      return true;
    }

    return false;
  }

  /// delete comment
  static Future deletePostComment(id) async {
    var delete = await AppServices.deletePostComment(id);

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
    var report = await AppServices.reportPostComment(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }

  /// edit comment
  static Future editPostComment(
    id, {
    required comment,
  }) async {
    var edit = await AppServices.editPostComment(
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
