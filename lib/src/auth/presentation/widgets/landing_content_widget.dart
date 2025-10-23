import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:vector_graphics/vector_graphics.dart';

SliverChildListDelegate contentWidget(BuildContext context) {
  final local = AppLocalizations.of(context);
  return SliverChildListDelegate([
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        local!.landingAppTitle,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(color: ColorValues.whiteColor),
        textAlign: TextAlign.left,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        local.landingAppSubtitle,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorValues.whiteColor),
        textAlign: TextAlign.left,
      ),
    ),
    SizedBox(height: heightQuery(context) * 0.05),
    Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: RotationTransition(
          turns: const AlwaysStoppedAnimation(15 / 360),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: iconTextButtonWidget(
              context: context,
              icon: const VectorGraphic(loader: AssetBytesLoader(IconAssets.plant)),
              label: local.anytime,
              backgroundColor: ColorValues.blackColor,
              foregroundColor: ColorValues.whiteColor,
              buttonType: ButtonType.large,
              onPressed: () {},
            ),
          ),
        ),
      ),
    ),
    Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: RotationTransition(
          turns: const AlwaysStoppedAnimation(-15 / 360),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: iconTextButtonWidget(
              context: context,
              icon: const VectorGraphic(loader: AssetBytesLoader(IconAssets.love)),
              label: local.anywhere,
              backgroundColor: ColorValues.blackColor,
              foregroundColor: ColorValues.whiteColor,
              buttonType: ButtonType.large,
              onPressed: () {},
            ),
          ),
        ),
      ),
    ),
  ]);
}
