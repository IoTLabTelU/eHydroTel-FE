import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/language_toggle_fab.dart';
import 'package:hydro_iot/utils/utils.dart';

import '../../../../core/core.dart';
import '../widgets/landing_content_widget.dart';

class LandingScreen extends StatelessWidget {
  static const String path = 'landing';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      height: heightQuery(context),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.authBackground),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: null),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: heightQuery(context) * 0.15)),
            SliverList(delegate: contentWidget(context)),
            SliverToBoxAdapter(child: SizedBox(height: heightQuery(context) * 0.1)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.6, sigmaY: 10.6),
                    child: primaryButton(
                      buttonType: ButtonType.medium,
                      color: ColorValues.whiteColor.withValues(alpha: 0.3),
                      text: local.getStartedButton,
                      onPressed: () async {
                        await Storage.setIsLoggedIn('false');
                        if (context.mounted) context.pushReplacement('/auth');
                      },
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: LanguageToggleFAB(width: widthQuery(context) * 0.3, height: heightQuery(context) * 0.065),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }
}
