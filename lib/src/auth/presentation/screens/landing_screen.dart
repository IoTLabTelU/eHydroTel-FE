import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/language_toggle_fab.dart';
import 'package:hydro_iot/utils/utils.dart';

import '../widgets/landing_appbar_widget.dart';
import '../widgets/landing_content_widget.dart';

class LandingScreen extends StatelessWidget {
  static const String path = 'landing';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorValues.whiteColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: ColorValues.blackColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
              ),
              flexibleSpace: appBarWidget(context),
              floating: true,
              snap: true,
              stretch: true,
              expandedHeight: heightQuery(context) * 0.3,
              collapsedHeight: heightQuery(context) * 0.45,
            ),
            SliverList(delegate: contentWidget(context)),
          ],
        ),
        floatingActionButton: LanguageToggleFAB(width: widthQuery(context) * 0.3),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),
    );
  }
}
