import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class ForgotPasswordContentWidget extends StatelessWidget {
  const ForgotPasswordContentWidget({super.key, required this.emailController, required this.send});

  final TextEditingController emailController;
  final VoidCallback send;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.05, vertical: heightQuery(context) * 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(37.0)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                local.forgotYourPassword,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                local.enterYourRegisteredEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormFieldComponent(
                label: 'Email',
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: widthQuery(context) * 0.5,
                child: primaryButton(text: local.sendCode, onPressed: send, context: context),
              ),
              SizedBox(height: 40.h),
              Text(
                ' ${local.youReceiveOneTimeCode} ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
