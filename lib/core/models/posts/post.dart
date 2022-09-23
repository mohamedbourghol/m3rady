

import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

import 'comments/comment.dart';
import 'like/likes.dart';
class Post {
  int id;
  String content;
  String websiteUrl;
  Map media;
  Map statistics;
  Map permissions;
  int? categoryId;
  User owner;
  bool isLiked;
  bool? isSaved;
  bool? isHidden;
  bool? isSubscribed;
  Map? comments ;
  List<LikesUsers>? likesUsers ;
  String? createdAt;
  bool isAdvertisement = false;

  Post({
    required this.id,
    required this.content,
    required this.websiteUrl,
    required this.media,
    required this.statistics,
    required this.permissions,
    this.categoryId,
    required this.owner,
    required this.isLiked,
    this.isSaved,
    this.isHidden,
    this.isSubscribed,
    this.comments,
    this.createdAt,
    this.isAdvertisement = false,
    this.likesUsers
  });

  /// Factory
  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      id: data['id'] as int,
      content: data['content'] as String,
      websiteUrl: data['websiteUrl'] as String,
      media: Media.generateMapWithIdFromJson(data['media']),
      comments: PostComment.generateMapWithIdFromJson(data['comments']),
      likesUsers: List<LikesUsers>.from(data["likesUsers"].map((x) => LikesUsers.fromJson(x))),
      statistics: {
        'views': data['statistics']!['views']! ?? 0,
        'likes': data['statistics']!['likes']! ?? 0,
        'comments': data['statistics']!['comments']! ?? 0,
      },
      permissions: {
        'isAllowActions': data['permissions']?['isAllowActions']! ?? false,
        'isAllowLike': data['permissions']?['isAllowLike']! ?? false,
        'isAllowComment': data['permissions']?['isAllowComment']! ?? false,
        'isAllowShare': data['permissions']?['isAllowShare']! ?? false,
        'isAllowSave': data['permissions']?['isAllowSave']! ?? false,
        'isAllowGetNotifications':
            data['permissions']?['isAllowGetNotifications']! ?? false,
        'isAllowHideCompanyPosts':
            data['permissions']?['isAllowHideCompanyPosts']! ?? false,
        'isAllowReport': data['permissions']?['isAllowReport']! ?? false,
        'isAllowEdit': data['permissions']?['isAllowEdit']! ?? false,
        'isAllowDelete': data['permissions']?['isAllowDelete']! ?? false,
      },
      categoryId: data['categoryId'],
      owner: User.fromJson(data['owner']),
      isLiked: data['isLiked'] == true,
      isSubscribed: data['isSubscribed'] == true,
      isSaved: data['isSaved'] == true,
      isHidden: data['isHidden'] == true,
      createdAt: data['createdAt'] ?? '',
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Post.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Create post
  static Future create({
    categoryId,
    required String content,
    Map? media,
  }) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var request = await AppServices.createPost(
      categoryId: categoryId,
      content: content,
      media: media,
    );

    if (request['status'] == true) {
      /// If post has data
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    return false;
  }

  /// Update post
  static Future update(
    id, {
    required content,
    required categoryId,
  }) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var request = await AppServices.updatePost(
      id,
      categoryId: categoryId,
      content: content,
    );

    if (request['status'] == true) {
      /// If post has data
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    print(request);

    return false;
  }

  /// Get posts (pagination)
  static Future getPosts({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getPosts(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (posts['status'] == true) {
      data['data'] = generateMapWithIdFromJson(posts['data']);
      data['pagination'] = posts['pagination'];
    }

    return data;
  }

  /// Get saved posts (pagination)
  static Future getSavedPosts({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getSavedPosts(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (posts['status'] == true) {
      data['data'] = generateMapWithIdFromJson(posts['data']);
      data['pagination'] = posts['pagination'];
    }

    return data;
  }

  /// Get posts search (pagination)
  static Future getPostsSearch({
    int? limit,
    int? page,
    keyword,
    categoryId,
    countryCode,
    cityId,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getPostsSearch(
      limit: limit,
      page: page,
      keyword: keyword,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (posts['status'] == true) {
      data['data'] = generateMapWithIdFromJson(posts['data']);
      data['pagination'] = posts['pagination'];
    }

    return data;
  }

  /// Get posts by id
  static Future getPostById(id) async {
    var post = await AppServices.getPostById(id);

    if (post['status'] == true) {
      return Post.fromJson(post['data']);
    }

    return false;
  }

  /// Get posts by advertiser id (pagination)
  static Future getPostsByAdvertiserId({
    required int id,
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getPostsByAdvertiserId(
      id: id,
      limit: limit,
      page: page,
    );

    if (posts['status'] == true) {
      data['data'] = generateMapWithIdFromJson(posts['data']);
      data['pagination'] = posts['pagination'];
    }

    return data;
  }

  /// Get posts by customer id (pagination)
  static Future getPostsByCustomerId({
    required int id,
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getPostsByCustomerId(
      id: id,
      limit: limit,
      page: page,
    );

    if (posts['status'] == true) {
      data['data'] = generateMapWithIdFromJson(posts['data']);
      data['pagination'] = posts['pagination'];
    }

    return data;
  }

  /// like post
  static Future likePost(id, isLiked) async {
    var like = await AppServices.likePost(
      id,
      isLiked: isLiked,
    );

    if (like['status'] == true) {
      return true;
    }

    return false;
  }

  /// subscribe post
  static Future subscribePost(id, isSubscribed) async {
    var subscribe = await AppServices.subscribePost(
      id,
      isSubscribed: isSubscribed,
    );

    if (subscribe['status'] == true) {
      return {
        'message': subscribe['message'],
        'data': subscribe['data'],
      };
    }

    return false;
  }

  /// save post
  static Future savePost(id, isSaved) async {
    var like = await AppServices.savePost(
      id,
      isSaved: isSaved,
    );

    if (like['status'] == true) {
      return {
        'message': like['message'],
        'data': like['data'],
      };
    }

    return false;
  }

  /// report post
  static Future reportPostById(id) async {
    var report = await AppServices.reportPostById(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }

  /// delete post
  static Future deletePost(id) async {
    var report = await AppServices.deletePost(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }

  /// Hide advertiser's posts
  static Future hidePostsByAdvertiserId(
      id, {
        bool? isHidden,
      }) async {
    /// Send request
    var hide = await AppServices.hideAdvertiserById(
      id,
      isHidden: isHidden,
    );

    if (hide['status'] == true) {
      return {
        'data': hide['data'],
        'message': hide['message'],
      };
    }

    return false;
  }
}
