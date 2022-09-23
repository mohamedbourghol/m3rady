import 'package:get_storage/get_storage.dart';

class LocalStorage {
  /// Initialize
  static Future init() async {
    await GetStorage.init();
  }

  /// Set variable
  static Future set(key, value) async {
    return await GetStorage().write(key, value);
  }

  /// Get variable
  static Future get(key) async {
    return await GetStorage().read(key);
  }

  /// Check variable
  static Future check(key) async {
    return GetStorage().hasData(key);
  }
}
