import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Offer {
  int id;
  String content;
  String websiteUrl;
  String? advertisementUrl;
  Map media;
  Map statistics;
  Map permissions;
  int? categoryId;
  double? salePercentage;
  User owner;
  bool isLiked;
  bool? isSaved;
  bool? isHidden;
  bool? isRated;
  bool? isSubscribed;
  List? comments = [];
  String createdAt;
  bool isExpired;
  double? rate;
  int expiresIn;

  Offer({
    required this.id,
    required this.content,
    required this.websiteUrl,
    this.advertisementUrl,
    required this.media,
    required this.statistics,
    required this.permissions,
    this.categoryId,
    required this.salePercentage,
    required this.owner,
    required this.isLiked,
    this.isSaved,
    this.isHidden,
    this.isRated,
    this.isSubscribed,
    this.comments,
    required this.createdAt,
    required this.isExpired,
    this.rate,
    required this.expiresIn,
  });

  /// Factory
  factory Offer.fromJson(Map<String, dynamic> data) {
    return Offer(
      id: data['id'] as int,
      content: data['content'] as String,
      websiteUrl: data['websiteUrl'] as String,
      advertisementUrl: data['advertisementUrl'],
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
        'isAllowRate': data['permissions']?['isAllowRate']! ?? false,
        'isAllowReport': data['permissions']?['isAllowReport']! ?? false,
        'isAllowEdit': data['permissions']?['isAllowEdit']! ?? false,
        'isAllowDelete': data['permissions']?['isAllowDelete']! ?? false,
      },
      categoryId: data['categoryId'],
      salePercentage: (data['salePercentage'] == null
          ? 0.0
          : double.parse(data['salePercentage'].toString())),
      owner: User.fromJson(data['owner']),
      isLiked: data['isLiked'] == true,
      isSubscribed: data['isSubscribed'] == true,
      isSaved: data['isSaved'] == true,
      isRated: data['isRated'] == true,
      isHidden: data['isHidden'] == true,
      isExpired: data['isExpired'] == true,
      rate:
          (data['rate'] == null ? 0.0 : double.parse(data['rate'].toString())),
      expiresIn: data['expiresIn'],
      createdAt: data['createdAt'] ?? '',
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Offer.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Create offer
  static Future create({
    categoryId,
    required String content,
    required String expiresIn,
    required String salePercentage,
    String? advertisementUrl,
    Map? media,
  }) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var request = await AppServices.createOffer(
      categoryId: categoryId,
      content: content,
      expiresIn: expiresIn,
      salePercentage: salePercentage,
      advertisementUrl: advertisementUrl,
      media: media,
    );

    if (request['status'] == true) {
      /// If offer has data
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    return false;
  }

  /// Update offer
  static Future update(
    id, {
    required content,
    required categoryId,
  }) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var request = await AppServices.updateOffer(
      id,
      categoryId: categoryId,
      content: content,
    );

    if (request['status'] == true) {
      /// If offer has data
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    print(request);

    return false;
  }

  /// Get offers (pagination)
  static Future getOffers({
    int? limit,
    int? page,
    categoryId,
    countryCode,
    cityId,
    bool? isShowMyOffersOnly = false,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var offers = await AppServices.getOffers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
      isShowMyOffersOnly: isShowMyOffersOnly,
    );

    if (offers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(offers['data']);
      data['pagination'] = offers['pagination'];
    }

    return data;
  }

  /// Get saved offers (pagination)
  static Future getSavedOffers({
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

    var offers = await AppServices.getSavedOffers(
      limit: limit,
      page: page,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (offers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(offers['data']);
      data['pagination'] = offers['pagination'];
    }

    return data;
  }

  /// Get offers search (pagination)
  static Future getOffersSearch({
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

    var offers = await AppServices.getOffersSearch(
      limit: limit,
      page: page,
      keyword: keyword,
      categoryId: categoryId,
      countryCode: countryCode,
      cityId: cityId,
    );

    if (offers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(offers['data']);
      data['pagination'] = offers['pagination'];
    }

    return data;
  }

  /// Get offers by id
  static Future getOfferById(id) async {
    var offer = await AppServices.getOfferById(id);

    if (offer['status'] == true) {
      return Offer.fromJson(offer['data']);
    }

    return false;
  }

  /// Get offers by advertiser id (pagination)
  static Future getOffersByAdvertiserId({
    required int id,
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var offers = await AppServices.getOffersByAdvertiserId(
      id: id,
      limit: limit,
      page: page,
    );

    if (offers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(offers['data']);
      data['pagination'] = offers['pagination'];
    }

    return data;
  }

  /// Get offers by customer id (pagination)
  static Future getOffersByCustomerId({
    required int id,
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var offers = await AppServices.getOffersByCustomerId(
      id: id,
      limit: limit,
      page: page,
    );

    if (offers['status'] == true) {
      data['data'] = generateMapWithIdFromJson(offers['data']);
      data['pagination'] = offers['pagination'];
    }

    return data;
  }

  /// like offer
  static Future likeOffer(id, isLiked) async {
    var like = await AppServices.likeOffer(
      id,
      isLiked: isLiked,
    );

    if (like['status'] == true) {
      return true;
    }

    return false;
  }

  /// subscribe offer
  static Future subscribeOffer(id, isSubscribed) async {
    var subscribe = await AppServices.subscribeOffer(
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

  /// save offer
  static Future saveOffer(id, isSaved) async {
    var like = await AppServices.saveOffer(
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

  /// report offer
  static Future reportOfferById(id) async {
    var report = await AppServices.reportOfferById(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }

  /// delete offer
  static Future deleteOffer(id) async {
    var report = await AppServices.deleteOffer(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }

  /// Hide advertiser's offers
  static Future hideOffersByAdvertiserId(
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

  /// rate offer
  static Future rateOffer({
    required id,
    required rate,
    comment,
  }) async {
    var request = await AppServices.rateOfferById(
      id: id,
      rate: rate,
      comment: comment,
    );

    if (request['status'] == true) {
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    return false;
  }
}
