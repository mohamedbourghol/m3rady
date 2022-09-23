import 'package:get/get.dart';
import 'package:m3rady/core/utils/langs/en.dart';
import 'package:m3rady/core/utils/langs/ar.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
}
