import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydro_iot/res/res.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorMessage;
  const ErrorScreen({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: ColorValues.danger600, size: 40.sp),
                Text(
                  'Error!',
                  style: jetBrainsMonoHeadText(color: ColorValues.danger600, size: 14.sp),
                  textAlign: TextAlign.center,
                ),
                Text(
                  errorMessage ?? 'Unknown error. Please contact support.',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 7.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
