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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error!',
                style: jetBrainsMonoHeadText(color: ColorValues.danger600),
                textAlign: TextAlign.center,
              ),
              Text(
                errorMessage ?? 'Unknown error. Please contact support.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorValues.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
