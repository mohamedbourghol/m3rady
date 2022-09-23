import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class PostAdvertisement {
  int id;
  int postId;
  String content;
  String? name;
  String? image;
  String? advertiserUrl;
  String websiteUrl;
  Map media;
  Map statistics;
  Map permissions;
  bool isLiked;
  List? comments = [];
  bool isAdvertisement = true;
  String? createdAt;

  PostAdvertisement({
    required this.id,
    required this.postId,
    required this.content,
    this.name,
    this.image,
    this.advertiserUrl,
    required this.websiteUrl,
    required this.media,
    required this.statistics,
    required this.permissions,
    required this.isLiked,
    this.comments,
    this.isAdvertisement = true,
    this.createdAt,
  });

  /// Factory
  factory PostAdvertisement.fromJson(Map<String, dynamic> data) {
    return PostAdvertisement(
      id: data['id'] as int,
      postId: data['postId'] as int,
      content: data['content'] ?? "",
      name: data['advertiserName'],
      image: data['advertiserImage'],
      advertiserUrl: data['advertiserUrl'],
      websiteUrl: data['websiteUrl'],
      media: Media.generateMapWithIdFromJson(data['media']),
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
      },
      isLiked: data['isLiked'] == true,
      createdAt: data['createdAt'] ?? '',
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = PostAdvertisement.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get posts advertisement (pagination)
  static Future getPostsAds({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
    isRandom = true,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var posts = await AppServices.getPostsAds(
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
}
