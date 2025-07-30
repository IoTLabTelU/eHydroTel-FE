import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/auth_appbar_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String path = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
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
                        'SIGN IN',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 20.h),
                      Text('Welcome back! Please sign in to continue.', style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: 20.h),
                      TextFormFieldComponent(
                        label: 'Email',
                        controller: emailController,
                        hintText: 'Enter your email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20.h),
                      TextFormFieldComponent(
                        label: 'Password',
                        controller: passwordController,
                        hintText: 'Enter your password',
                        obscureText: true,
                      ),
                      SizedBox(height: 20.h),
                      TextButton(
                        onPressed: () {
                          context.push('/forgot-password');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: primaryButton(
                          text: 'LOGIN',
                          onPressed: () {
                            context.pushReplacement('/dashboard');
                          },
                          context: context,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(color: ColorValues.neutral400, radius: BorderRadius.circular(10)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.neutral600),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: ColorValues.neutral400, radius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          'Don\'t have an account?',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: ColorValues.neutral400, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: secondaryButton(
                          text: 'REGISTER',
                          onPressed: () {
                            context.pushReplacement('/register');
                          },
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
