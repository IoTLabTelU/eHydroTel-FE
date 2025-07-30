import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydro_iot/res/res.dart';

Widget primaryButton({
  required String text,
  required VoidCallback onPressed,
  required BuildContext context,
  Color? color,
  double? width,
  double? height,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.iotMainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
    ),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.neutral200, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}

Widget secondaryButton({required String text, required VoidCallback onPressed, required BuildContext context}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.neutral200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
    ),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}
