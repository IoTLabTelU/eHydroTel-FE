import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/content_widget.dart';

class LandingScreen extends StatelessWidget {
  static const String path = 'landing';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: ColorValues.blackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
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
      ),
    );
  }
}
