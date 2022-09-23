import 'package:get_storage/get_storage.dart';
import 'package:m3rady/core/models/system/cities/city.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Country {
  int? id;
  String code;
  String name;
  Map? cities;

  Country({
    this.id,
    required this.code,
    required this.name,
    this.cities,
  });

  /// Factory
  factory Country.fromJson(Map<String, dynamic> data) {
    return Country(
      id: data['id'] as int,
      code: data['code'] as String,
      name: data['name'] as String,
      cities: City.generateMapWithIdFromJson(data['cities']),
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Country.fromJson(value);

        /// Set data
        data[entry.code.toString()] = entry;
      });
    }

    return data;
  }

  /// Get all data
  static Future getCountries() async {
    final box = GetStorage();
    var countries=box.read('country');
     if(countries==null)
       {print('on');
         countries = await AppServices.getCountries();

         if (countries['status'] == true) {
           box.write('country',countries['data']);
           return generateMapWithIdFromJson(countries['data']);

         }
       }
     else{
       print('of');
       return generateMapWithIdFromJson(countries);
     }


    return {};
  }
}
