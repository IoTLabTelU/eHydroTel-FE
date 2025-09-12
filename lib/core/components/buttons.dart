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

Widget searchButton({required VoidCallback onPressed, required BuildContext context, required String text}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(color: ColorValues.neutral200, borderRadius: BorderRadius.circular(20.r)),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(labelText: text, border: InputBorder.none, prefixIcon: const Icon(Icons.search)),
      ),
    ),
  );
}

Widget iconTextButtonWidget({
  required BuildContext context,
  required Widget icon,
  required String label,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: ColorValues.neutral200),
      ),
    ),
    icon: icon,
    label: Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: foregroundColor ?? ColorValues.neutral500, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    onPressed: onPressed,
  );
}
