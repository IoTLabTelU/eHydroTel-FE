import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:lottie/lottie.dart';

Widget appBarWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          padding: const EdgeInsets.all(16.0),
          child: Lottie.asset(
            LottieAssets.landingPlant,
            width: 60.w,
            height: 100.h,
            repeat: true,
            fit: BoxFit.cover,
            frameRate: FrameRate.max,
          ),
        ),
        Text(AppStrings.appName, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorValues.whiteColor)),
      ],
    ),
  );
}
