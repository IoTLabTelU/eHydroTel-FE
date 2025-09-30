import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/utils/storage.dart';

import '../../../../res/res.dart';

SliverChildListDelegate contentWidget(BuildContext context) {
  final local = AppLocalizations.of(context);
  return SliverChildListDelegate([
    Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        local!.landingAppTitle,
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        '${AppStrings.appName} ${local.landingAppSubtitle}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ColorValues.blackColor),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: primaryButton(
        text: local.getStartedButton,
        onPressed: () async {
          await Storage.setIsLoggedIn('false');
          if (context.mounted) context.pushReplacement('/login');
        },
        context: context,
      ),
    ),
  ]);
}
