import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';

import '../../../../utils/utils.dart';

class LoginContentWidget extends StatelessWidget {
  const LoginContentWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.login,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback login;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.05, vertical: heightQuery(context) * 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(37.0)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ImageAssets.logo,
                width: 120.w,
                height: 120.h,
                cacheWidth: (100 * MediaQuery.of(context).devicePixelRatio).toInt(),
                cacheHeight: (100 * MediaQuery.of(context).devicePixelRatio).toInt(),
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
              SizedBox(height: 10.h),
              TextFormFieldComponent(
                label: 'Password',
                controller: passwordController,
                hintText: 'Enter your password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: widthQuery(context) * 0.5,
                child: primaryButton(text: local.signInTitle, onPressed: login, context: context),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  context.push('/forgot-password');
                },
                child: Text(
                  local.forgotPassword,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' ${local.dontHaveAccount} ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/register');
                    },
                    child: Text(
                      local.signUp,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
