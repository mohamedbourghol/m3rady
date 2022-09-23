import 'package:m3rady/core/utils/services/AppServices.dart';

class BusinessType {
  int id;
  String name;

  BusinessType({
    required this.id,
    required this.name,
  });

  /// Factory
  factory BusinessType.fromJson(Map<String, dynamic> data) {
    return BusinessType(
      id: data['id'] as int,
      name: data['name'] as String,
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = BusinessType.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get all data
  static Future getBusinessTypes() async {
    var types = await AppServices.getBusinessTypes();
    if (types['status'] == true) {
      return generateMapWithIdFromJson(types['data']);
    }
    return {};
  }
}
