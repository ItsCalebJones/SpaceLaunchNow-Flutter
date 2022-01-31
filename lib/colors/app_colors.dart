import 'package:flutter/material.dart';

class SpaceLaunchNowColors {
  SpaceLaunchNowColors._(); // this basically makes it so you can instantiate this class
  static const _greenPrimaryValue = 0xFF3a6d70;
  static const Color blueTransparent = Color(0xf02196F3);

  static const MaterialColor primary = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xFF9cb6b7),
      100: Color(0xFF88a7a9),
      200: Color(0xFF75989a),
      300: Color(0xFF618a8c),
      400: Color(0xFF4d7b7e),
      500: Color(_greenPrimaryValue),
      600: Color(0xFF346264),
      700: Color(0xFF2e5759),
      800: Color(0xFF284c4e),
      900: Color(0xFF224143),
    },
  );

  static const _greyPrimaryValue = 0xFFd8d8d8;

  static const MaterialColor secondary = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFebebeb),
      100: Color(0xFFe7e7e7),
      200: Color(0xFFe3e3e3),
      300: Color(0xFFdfdfdf),
      400: Color(0xFFdbdbdb),
      500: Color(_greyPrimaryValue),
      600: Color(0xFFc2c2c2),
      700: Color(0xFFacacac),
      800: Color(0xFF979797),
      900: Color(0xFF818181),
    },
  );
}
