class SocialAccounts {
  String? contactNumber;
  String? whatsappNumber;
  String? facebookUrl;
  String? twitterUrl;
  String? websiteUrl;
  SocialAccounts({
    this.contactNumber,
    this.whatsappNumber,
    this.facebookUrl,
    this.twitterUrl,
    this.websiteUrl,
  });

  /// Factory
  factory SocialAccounts.fromJson(Map<String, dynamic> data) {
    return SocialAccounts(
      contactNumber: data['contactNumber'] ?? null,
      facebookUrl: data['facebookUrl'] ?? null,
      twitterUrl: data['twitterUrl'] ?? null,
      websiteUrl: data['websiteUrl'] ?? null,
      whatsappNumber: data['whatsappNumber'] ?? null,
    );
  }
}
