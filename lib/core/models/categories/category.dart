import 'package:get_storage/get_storage.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Category {
  int id;
  int? parentId;
  String name;
  String imageUrl;
  Map? subCategories;
  bool? isSelected = false;

  Category({
    required this.id,
    this.parentId,
    required this.name,
    required this.imageUrl,
    this.subCategories,
    this.isSelected = false,
  });

  /// Factory
  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
      id: data['id'] as int,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] ?? '',
      subCategories: generateMapWithIdFromJson(data['subCategories']),
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Category.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get all data
  static Future getCategories() async {
    final box = GetStorage();
    var categories=box.read('cate');
     if(categories==null)
       {
         print('on');
         categories = await AppServices.getCategories();
         if (categories['status'] == true) {
           box.write('cate', categories['data']);
           return generateMapWithIdFromJson(categories['data']);
         }
       }
     else{
       print('of');
       return generateMapWithIdFromJson(categories);
     }

    return {};
  }
}
