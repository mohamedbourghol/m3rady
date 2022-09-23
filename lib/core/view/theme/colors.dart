import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationColors {
  static String brightness =
      Get.theme.brightness == Brightness.light ? 'light' : 'dark';

  static Map<String, Color> lightColors = {
    'primary': Color(0xff2585C7),
    'secondary': Colors.orange,
  };

  static Map<String, Color> darkColors = {
    'primary': Color(0xff2585C7),
    'secondary': Colors.orange,
  };

  static Map<String, Color> colors =
      (brightness == 'light' ? lightColors : darkColors);
}
