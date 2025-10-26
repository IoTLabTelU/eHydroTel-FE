import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:vector_graphics/vector_graphics.dart';

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

Widget searchButton({
  required VoidCallback onPressed,
  required BuildContext context,
  required String text,
  bool enabled = false,
  TextEditingController? controller,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: ColorValues.neutral100,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: ColorValues.neutral200),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
          contentPadding: EdgeInsets.symmetric(vertical: 6.5.h, horizontal: 16.w),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: const VectorGraphic(loader: AssetBytesLoader(IconAssets.search)),
          ),
        ),
      ),
    ),
  );
}

Widget filterButton({required VoidCallback onPressed, required BuildContext context}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: const CircleBorder(side: BorderSide(color: ColorValues.blackColor)),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    ),
    child: const VectorGraphic(loader: AssetBytesLoader(IconAssets.filter)),
  );
}

Widget addButton({required BuildContext context, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.green600,
      shape: const CircleBorder(),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    ),
    child: const VectorGraphic(
      loader: AssetBytesLoader(IconAssets.add),
      colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
    ),
  );
}

Widget editButton({required BuildContext context, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.warning200,
      shape: const CircleBorder(),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    ),
    child: const VectorGraphic(
      loader: AssetBytesLoader(IconAssets.edit),
      colorFilter: ColorFilter.mode(ColorValues.warning700, BlendMode.srcIn),
    ),
  );
}

Widget historyButton({required BuildContext context, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.neutral200,
      shape: const CircleBorder(),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
    ),
    child: const VectorGraphic(loader: AssetBytesLoader(IconAssets.history), width: 16, height: 16),
  );
}

Widget harvestButton({required BuildContext context, required VoidCallback onPressed}) {
  final local = AppLocalizations.of(context)!;
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.green600,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
      padding: EdgeInsets.symmetric(vertical: 8.h),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          local.harvest,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        const VectorGraphic(loader: AssetBytesLoader(IconAssets.harvest), width: 20, height: 20),
      ],
    ),
  );
}

Widget cancelButton({required BuildContext context, required VoidCallback onPressed}) {
  final local = AppLocalizations.of(context)!;
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorValues.neutral100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
    ),
    child: Text(
      local.cancel,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ColorValues.blueProgress, fontWeight: FontWeight.w600),
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
