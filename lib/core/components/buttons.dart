import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydro_iot/res/res.dart';

enum ButtonType { small, medium, large, extraLarge }

Widget primaryButton({
  required String text,
  required VoidCallback onPressed,
  required BuildContext context,
  ButtonType buttonType = ButtonType.medium,
  Color? color,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? ColorValues.blackColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
    ),
    child: Text(
      text,
      style: buttonType == ButtonType.small
          ? Theme.of(context).textTheme.labelMedium?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w600)
          : buttonType == ButtonType.medium
          ? Theme.of(context).textTheme.titleSmall?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w600)
          : buttonType == ButtonType.large
          ? Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w600)
          : Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    ),
  );
}

Widget secondaryButton({
  required String text,
  required VoidCallback onPressed,
  required BuildContext context,
  ButtonType buttonType = ButtonType.medium,
  Color? color,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
        side: const BorderSide(color: ColorValues.neutral100),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
    ),
    child: Text(
      text,
      style: buttonType == ButtonType.small
          ? Theme.of(context).textTheme.labelMedium?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600)
          : buttonType == ButtonType.medium
          ? Theme.of(context).textTheme.titleSmall?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600)
          : buttonType == ButtonType.large
          ? Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600)
          : Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    ),
  );
}

Widget searchButton({required VoidCallback onPressed, required BuildContext context}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(color: ColorValues.iotNodeMCUColor, shape: BoxShape.circle),
      child: const TextField(
        enabled: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Center(child: Icon(Icons.search, color: ColorValues.whiteColor)),
        ),
      ),
    ),
  );
}

Widget iconTextButtonWidget({
  required BuildContext context,
  required Widget icon,
  required String label,
  required VoidCallback onPressed,
  ButtonType buttonType = ButtonType.medium,
  Color? backgroundColor,
  Color? foregroundColor,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
    ),
    icon: icon,
    label: Text(
      label,
      style: buttonType == ButtonType.small
          ? Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: foregroundColor ?? ColorValues.neutral500, fontWeight: FontWeight.bold)
          : buttonType == ButtonType.medium
          ? Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: foregroundColor ?? ColorValues.neutral500, fontWeight: FontWeight.bold)
          : buttonType == ButtonType.large
          ? Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: foregroundColor ?? ColorValues.neutral500, fontWeight: FontWeight.bold)
          : Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: foregroundColor ?? ColorValues.neutral500, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    onPressed: onPressed,
  );
}
