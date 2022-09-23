import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Rate {
  int id;
  double rate;
  String? comment;
  User owner;
  String? createdAt;

  Rate({
    required this.id,
    required this.rate,
    this.comment,
    required this.owner,
    this.createdAt,
  });

  /// Factory
  factory Rate.fromJson(Map<String, dynamic> data) {
    return Rate(
      id: data['id'] as int,
      rate:
          (data['rate'] == null ? 0.0 : double.parse(data['rate'].toString())),
      comment: data['comment'] as String,
      owner: User.fromJson(data['owner']),
      createdAt: data['createdAt'] ?? '',
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Rate.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get rates by advertiser id (pagination)
  static Future getRatesByAdvertiserId(
    id, {
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var rates = await AppServices.getRatesByAdvertiserId(
      id,
      limit: limit,
      page: page,
    );

    if (rates['status'] == true) {
      data['data'] = generateMapWithIdFromJson(rates['data']);
      data['pagination'] = rates['pagination'];
    }

    return data;
  }

  /// rate advertiser
  static Future rateAdvertiserById({
    required id,
    required rate,
    comment,
  }) async {
    var request = await AppServices.rateAdvertiserById(
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
