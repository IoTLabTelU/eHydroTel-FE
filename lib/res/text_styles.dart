import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'res.dart';

TextStyle dmSansHeadText({
  double size = 20,
  FontWeight weight = FontWeight.w700,
  Color? color,
  FontStyle? italic,
}) {
  return GoogleFonts.dmSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? ColorValues.blackColor,
    fontStyle: italic ?? FontStyle.normal,
  );
}

TextStyle dmSansNormalText({
  double size = 14,
  FontWeight weight = FontWeight.w500,
  Color? color,
  FontStyle? italic,
}) {
  return GoogleFonts.dmSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? ColorValues.blackColor,
    fontStyle: italic ?? FontStyle.normal,
  );
}

TextStyle dmSansSmallText({
  double size = 10,
  FontWeight weight = FontWeight.w300,
  Color? color,
  FontStyle? italic,
}) {
  return GoogleFonts.dmSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? ColorValues.blackColor,
    fontStyle: italic ?? FontStyle.normal,
  );
}

TextStyle jetBrainsMonoHeadText({
  double size = 20,
  FontWeight weight = FontWeight.w700,
  Color? color,
  FontStyle? italic,
}) {
  return GoogleFonts.jetBrainsMono(
    fontSize: size,
    fontWeight: weight,
    color: color ?? ColorValues.blackColor,
    fontStyle: italic ?? FontStyle.normal,
  );
}

TextStyle jetBrainsMonoNormalText({
  double size = 14,
  FontWeight weight = FontWeight.w500,
  Color? color,
  FontStyle? italic,
}) {
  return GoogleFonts.jetBrainsMono(
    fontSize: size,
    fontWeight: weight,
    color: color ?? ColorValues.blackColor,
    fontStyle: italic ?? FontStyle.normal,
  );
}

TextStyle jetBrainsMonoSmallText({
  double size = 10,
  FontWeight weight = FontWeight.w300,
  Color? color,
  FontStyle? italic,
}) {
  return GoogleFonts.jetBrainsMono(
    fontSize: size,
    fontWeight: weight,
    color: color ?? ColorValues.blackColor,
    fontStyle: italic ?? FontStyle.normal,
  );
}
