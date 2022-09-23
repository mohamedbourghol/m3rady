class City {
  int id;
  String name;
  String? counrtyCode;

  City({
    required this.id,
    required this.name,
    this.counrtyCode,
  });

  /// Factory
  factory City.fromJson(Map<String, dynamic> data) {
    return City(
      id: data['id'] as int,
      counrtyCode: (data['counrtyCode'] ?? '') as String,
      name: data['name'] as String,
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = City.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }
}
