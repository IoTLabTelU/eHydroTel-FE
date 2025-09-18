import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_iot/core/components/components.dart';

import '../../../../res/res.dart';

SliverChildListDelegate contentWidget(BuildContext context) {
  return SliverChildListDelegate([
    Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        'Hydroponic IoT \nPlatform',
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        '${AppStrings.appName} is a platform that allows you to monitor and control your hydroponic needs seamlessly.',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ColorValues.blackColor),
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: primaryButton(
        text: 'GET STARTED',
        onPressed: () {
          context.pushReplacement('/login');
        },
        context: context,
      ),
    ),
  ]);
}
