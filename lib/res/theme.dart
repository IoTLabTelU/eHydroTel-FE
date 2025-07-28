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
      colorScheme: ColorScheme.fromSeed(seedColor: ColorValues.whiteColor),
    );
  }
}
