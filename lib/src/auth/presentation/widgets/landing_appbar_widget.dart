import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydro_iot/res/res.dart';

Widget appBarWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: ColorValues.iotMainColor, borderRadius: BorderRadius.circular(20)),
          child: SvgPicture.asset(
            IconAssets.logo,
            height: 80.h,
            width: 80.w,
            colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
          ),
        ),
        Text('Hydro IoT', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorValues.whiteColor)),
      ],
    ),
  );
}
