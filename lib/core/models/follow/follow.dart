import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Follow {
  int id;
  User owner;
  FollowStatus status;
  String? createdAt;

  Follow({
    required this.id,
    required this.owner,
    required this.status,
    required this.createdAt,
  });

  /// Factory
  factory Follow.fromJson(Map<String, dynamic> data) {
    return Follow(
      id: data['id'] as int,
      owner: User.fromJson(data['owner']),
      status: User.getFollowStatusFromJson(data['status']),
      createdAt: data['createdAt'] as String,
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Follow.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get followers (pagination)
  static Future getFollowers({
    int? limit,
    int? page,
    String? userType,
    int? userId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var followers = await AppServices.getFollowers(
      limit: limit,
      page: page,
      userType: userType,
      userId: userId,
    );

    if (followers['status'] == true) {
      data['data'] = User.generateMapWithIdFromJson(followers['data']);
      data['pagination'] = followers['pagination'];
    }

    return data;
  }

  /// Get followed (pagination)
  static Future getFollowed({
    int? limit,
    int? page,
    String? userType,
    int? userId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var followers = await AppServices.getFollowed(
      limit: limit,
      page: page,
      userType: userType,
      userId: userId,
    );

    if (followers['status'] == true) {
      data['data'] = User.generateMapWithIdFromJson(followers['data']);
      data['pagination'] = followers['pagination'];
    }

    return data;
  }

  /// Get follow requests (pagination)
  static Future getFollowRequests({
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var followers = await AppServices.getFollowRequests(
      limit: limit,
      page: page,
    );

    if (followers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(followers['data']);
      data['pagination'] = followers['pagination'];
    }

    return data;
  }

  /// toggle follow user
  static Future toggleFollowUser({
    required id,
    required type,
    isFollow,
  }) async {
    var follow = await AppServices.toggleFollowUser(
      id: id,
      type: type,
      isFollow: isFollow,
    );

    if (follow['status'] == true) {
      return {
        'message': follow['message'],
        'data': follow['data'],
      };
    }

    return false;
  }

  /// Update follow request
  static Future updateFollowRequest(
    id, {
    required status,
  }) async {
    var edit = await AppServices.updateFollowRequest(
      id,
      status: status,
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
