import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/auth_appbar_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const String path = 'change-password';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            appBarWidget(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: heightQuery(context) * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHANGE PASSWORD',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Create a new, strong password that you don\'t use before.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 20.h),
                    TextFormFieldComponent(
                      label: 'New Password',
                      controller: newPasswordController,
                      hintText: 'Enter your new password',
                      obscureText: true,
                    ),
                    SizedBox(height: 20.h),
                    TextFormFieldComponent(
                      label: 'Confirm Password',
                      controller: newConfirmController,
                      hintText: 'Confirm your new password',
                      obscureText: true,
                    ),
                    SizedBox(height: heightQuery(context) * 0.3),
                    SizedBox(
                      width: double.infinity,
                      child: primaryButton(text: 'VERIFY', onPressed: () {}, context: context),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
