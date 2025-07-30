import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/auth_appbar_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String path = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
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
                        'SIGN UP',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Looks like you don\'t have an account! Please fill the form to create an account.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 20.h),
                      TextFormFieldComponent(
                        label: 'Name',
                        controller: nameController,
                        hintText: 'Enter your name',
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'By clicking "REGISTER", you agree to our ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to Terms of Service
                                },
                                child: Text(
                                  'Terms of Service',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                                ),
                              ),
                            ),
                            WidgetSpan(child: Text(' & ', style: Theme.of(context).textTheme.bodyLarge)),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to Privacy Policy
                                },
                                child: Text(
                                  'Privacy Policy.',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: primaryButton(text: 'REGISTER', onPressed: () {}, context: context),
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
                          'Already have an account?',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: ColorValues.neutral400, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: secondaryButton(
                          text: 'LOGIN',
                          onPressed: () {
                            context.pushReplacement('/login');
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
