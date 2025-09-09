import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

SliverAppBar appBarWidget(BuildContext context) {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    flexibleSpace: Padding(
      padding: EdgeInsets.symmetric(vertical: heightQuery(context) * 0.025, horizontal: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 15.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: ColorValues.iotMainColor, borderRadius: BorderRadius.circular(20)),
            child: SvgPicture.asset(
              IconAssets.logo,
              height: 30.h,
              width: 30.w,
              colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            AppStrings.appName,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ),
    backgroundColor: ColorValues.success200,
    expandedHeight: heightQuery(context) * 0.15,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
    ),
  );
}
