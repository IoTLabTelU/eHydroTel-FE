import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/oauth_button_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

Widget authContentWidget({
  required BuildContext context,
  required VoidCallback loginWithGoogle,
  required VoidCallback login,
  required VoidCallback register,
}) {
  final local = AppLocalizations.of(context)!;
  return Center(
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.05, vertical: heightQuery(context) * 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(37.0)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.logo,
              width: 120.w,
              height: 120.h,
              cacheWidth: (100 * MediaQuery.of(context).devicePixelRatio).toInt(),
              cacheHeight: (100 * MediaQuery.of(context).devicePixelRatio).toInt(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: primaryButton(text: local.signInTitle, onPressed: login, context: context),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: secondaryButton(text: local.registerTitle, onPressed: register, context: context),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                local.or,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10.h),
            oAuthButtonWidget(
              context: context,
              assetName: IconAssets.googleIcon,
              label: local.signInWithGoogle,
              onPressed: loginWithGoogle,
            ),
            const SizedBox(height: 30),
            Text(
              local.authDisclaimer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
              textAlign: TextAlign.center,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    local.termsOfService,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                  ),
                ),
                Text(
                  ' ${local.and} ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    local.privacyPolicy,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
