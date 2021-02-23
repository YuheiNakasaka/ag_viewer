import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

enum Flavor { development, production }

@immutable
class Constants {
  const Constants();

  factory Constants.of() {
    if (_instance != null) {
      return _instance;
    }

    final flavor = EnumToString.fromString(
      Flavor.values,
      const String.fromEnvironment('FLAVOR'),
    );

    switch (flavor) {
      case Flavor.development:
        _instance = Constants._dev();
        break;
      case Flavor.production:
        _instance = Constants._prd();
        break;
    }
    return _instance;
  }

  factory Constants._dev() {
    return const Constants();
  }

  factory Constants._prd() {
    return const Constants();
  }

  bool isDev() {
    final flavor = EnumToString.fromString(
      Flavor.values,
      const String.fromEnvironment('FLAVOR'),
    );
    return flavor == Flavor.development;
  }

  bool isPrd() {
    final flavor = EnumToString.fromString(
      Flavor.values,
      const String.fromEnvironment('FLAVOR'),
    );
    return flavor == Flavor.production;
  }

  static Constants _instance;

  // common
  static String playStoreURL =
      'http://play.google.com/store/apps/details?id=<hoge-id>';
  static String appleStoreURL = 'https://itunes.apple.com/app/id<hoge-id>';

  static Color baseColor = const Color(0xFF212121);
  static Color mainColor = const Color(0xFF9E9E9E);
  static Color activeColor = const Color(0xFFFAFAFA);
  static Color bkColor = const Color(0xFF000000);
  static Color acccentColor = const Color(0xFFE30068);
}
