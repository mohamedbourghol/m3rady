import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class LikesUsers {
  int id;
  String? name;
  String? username;
  String? imageUrl;

  String? bio;
  String? countryCode;

  LikesUsers({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.bio,
    required this.countryCode
  });

  /// Factory
  factory LikesUsers.fromJson(Map<String, dynamic> data) {
    return LikesUsers(
      id: data['id'] as int,
      name: data['name'] as String,
      username: data['username']??'',
      imageUrl: data['imageUrl'] ??'',
      bio: data['bio'] ??'',
      countryCode: data['countryCode'] ??'',

    );
  }

  static generateLikesUsersFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = LikesUsers.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }









}
