import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m3rady/core/view/theme/colors.dart';

class ApplicationTheme {
  static ThemeData light = ThemeData(
    fontFamily: 'Cairo',
    primaryColor: Colors.white,
    backgroundColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0, foregroundColor: Colors.white),
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blue,

        /// navigation bar color
        statusBarColor: Colors.blue,

        /// status bar color
      ),
      color: ApplicationColors.colors['primary'],
      centerTitle: true,
      titleSpacing: 12,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
      ),
    ),
    //accentColor: config.Colors().mainColor(1),
    //dividerColor: config.Colors().accentColor(0.1),
    //focusColor: config.Colors().accentColor(1),
    //hintColor: config.Colors().secondColor(1),
    textTheme: TextTheme(
      headline5: TextStyle(
          fontSize: 22.0,
          //color: config.Colors().secondColor(1),
          height: 1.3),
      headline4: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          //color: config.Colors().secondColor(1),
          height: 1.3),
      headline3: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          //color: config.Colors().secondColor(1),
          height: 1.3),
      headline2: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          //color: config.Colors().mainColor(1),
          height: 1.4),
      headline1: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w300,
          //color: config.Colors().secondColor(1),
          height: 1.4),
      subtitle1: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w500,
          //color: config.Colors().secondColor(1),
          height: 1.2),
      headline6: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w700,
          //color: config.Colors().mainColor(1),
          height: 1.3),
      bodyText2: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          //color: config.Colors().secondColor(1),
          height: 1.2),
      bodyText1: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          //color: config.Colors().secondColor(1),
          height: 1.3),
      caption: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w300,
          //color: config.Colors().accentColor(1),
          height: 1.2),
    ),
  );

  static ThemeData dark = light;
}
