import 'package:m3rady/core/utils/services/AppServices.dart';

class Package {
  int id;
  String? productId;
  String name;
  String? description;
  List? specifications;
  String price;
  String? oldPrice;
  String currency;
  int duration;
  String subscriptionType;
  int? maximumPosts;
  bool? isSubscribed = false;
  bool? isTrial = false;
  String? endsAt;

  Package({
    required this.id,
    required this.name,
    this.productId,
    this.description,
    this.specifications,
    required this.price,
    required this.oldPrice,
    required this.currency,
    required this.duration,
    required this.subscriptionType,
    this.maximumPosts,
    this.isSubscribed,
    this.isTrial,
    this.endsAt,
  });

  /// Factory
  factory Package.fromJson(Map<String, dynamic> data) {
    return Package(
      id: data['id'] as int,
      productId: data['productId'],
      name: data['name'],
      description: data['description'],
      specifications: data['specifications'],
      price: data['price'],
      oldPrice: data['oldPrice'],
      currency: data['currency'],
      duration: data['duration'],
      subscriptionType: data['subscriptionType'],
      maximumPosts: data['maximumPosts'],
      isSubscribed: data['isSubscribed'],
      isTrial: data['isTrial'],
      endsAt: data['endsAt'],
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Package.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get packages
  static Future getPackages() async {
    var packages = await AppServices.getPackages();

    if (packages['status'] == true) {
      return Package.generateMapWithIdFromJson(packages['data']);
    }

    return false;
  }

  /// Get user package
  static Future getUserPackage() async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(false);

    var packages = await AppServices.getUserPackage();

    if (packages['status'] == true) {
      return Package.fromJson(packages['data']);
    }

    return false;
  }

  /// Validate package
  static Future validatePackage({
    productId,
    verificationData,
    deviceOS,
    transactionDate,
    purchaseID,
    status,
    source,
  }) async {
    var package = await AppServices.validatePackage(
      productId: productId,
      verificationData: verificationData,
      deviceOS: deviceOS,
      transactionDate: transactionDate,
      purchaseID: purchaseID,
      status: status,
      source: source,
    );

    if (package['status'] == true) {
      return {'message': package['message']};
    }

    return false;
  }

  /// Send identifier
  static Future sendPackageIdentifier({
    productId,
    purchaseID,
    identifier,
    deviceOS,
    transactionDate,
    status,
    source,
  }) async {
    var package = await AppServices.sendPackageIdentifier(
      productId: productId,
      purchaseID: purchaseID,
      identifier: identifier,
      deviceOS: deviceOS,
      transactionDate: transactionDate,
      status: status,
      source: source,
    );

    if (package['status'] == true) {
      return {'message': package['message']};
    }

    return false;
  }
}
