import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'res.dart';

class AppThemeData {
  static ThemeData getTheme() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      primaryColor: ColorValues.iotMainColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorValues.whiteColor,
      textTheme: GoogleFonts.dmSansTextTheme(Typography.blackCupertino),
      colorScheme: ColorScheme.fromSeed(seedColor: ColorValues.whiteColor, brightness: Brightness.light),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      primaryColor: ColorValues.iotMainColor,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorValues.blackColor,
      textTheme: GoogleFonts.dmSansTextTheme(Typography.whiteCupertino),
      colorScheme: ColorScheme.fromSeed(seedColor: ColorValues.blackColor, brightness: Brightness.dark),
    );
  }
}
