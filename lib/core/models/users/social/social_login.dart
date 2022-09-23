class SocialLogin {
  String provider;
  String? providerId;

  SocialLogin({
    required this.provider,
    this.providerId,
  });

  /// Factory
  factory SocialLogin.fromJson(Map<String, dynamic> data) {
    return SocialLogin(
      provider: data['provider'],
      providerId: data['providerId'],
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = SocialLogin.fromJson({
          'provider': value,
        });

        /// Set data
        data[entry.provider.toString()] = entry;
      });
    }

    return data;
  }
}
