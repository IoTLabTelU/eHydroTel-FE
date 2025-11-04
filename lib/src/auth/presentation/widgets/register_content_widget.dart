import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class RegisterContentWidget extends StatelessWidget {
  const RegisterContentWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.register,
    required this.nameController,
    required this.formKey,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback register;
  final GlobalKey<FormState> formKey;

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
          child: Form(
            key: formKey,
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
                  label: 'Name',
                  controller: nameController,
                  hintText: 'Enter your name',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
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
                    if (value.length < 6) {
                      return 'Must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: widthQuery(context) * 0.5,
                  child: primaryButton(text: local.signUp, onPressed: register, context: context),
                ),
                const SizedBox(height: 30),
                Text(
                  local.authDisclaimer,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                  textAlign: TextAlign.center,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        local.termsOfService,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                      ),
                    ),
                    Text(
                      ' ${local.and} ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        local.privacyPolicy,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
