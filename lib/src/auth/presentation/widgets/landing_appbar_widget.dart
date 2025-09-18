import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/mediaquery.dart';
import 'package:lottie/lottie.dart';

Widget appBarWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.all(16.0),
          child: Lottie.asset(
            LottieAssets.iotDevice,
            width: widthQuery(context) * 0.6,
            height: heightQuery(context) * 0.25,
            repeat: true,
            fit: BoxFit.cover,
            frameRate: FrameRate.max,
          ),
        ),
        Text(
          AppStrings.appName,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
