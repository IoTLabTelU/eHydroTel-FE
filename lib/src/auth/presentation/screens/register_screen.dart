import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/register_with_password_controller.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/auth_appbar_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

import '../widgets/oauth_button_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const String path = 'register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void register() async {
      if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: 'Please fill in all fields');
        return;
      }
      try {
        final res = await ref
            .read(registerWithPasswordControllerProvider.notifier)
            .registerWithEmailPassword(nameController.text, emailController.text, passwordController.text);
        if (context.mounted && res) {
          Toast().showSuccessToast(context: context, title: 'Registration successful, please login');
          context.pushReplacement('/login');
        }
      } catch (e) {
        if (context.mounted) Toast().showErrorToast(context: context, title: e.toString());
      }
    }

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
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: heightQuery(context) * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIGN UP',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Looks like you don\'t have an account! Please fill the form to create an account.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                      ),
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 20.h),
                      TextFormFieldComponent(
                        label: 'Email',
                        controller: emailController,
                        hintText: 'Enter your email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'By clicking "REGISTER", you agree to our ',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
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
                            WidgetSpan(child: Text(' & ', style: Theme.of(context).textTheme.bodyLarge?.copyWith())),
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
                        child: primaryButton(text: 'REGISTER', onPressed: register, context: context),
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
                            child: Text('OR', style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
                          ),
                          Expanded(
                            child: Divider(color: ColorValues.neutral400, radius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      oAuthButtonWidget(
                        context: context,
                        assetName: IconAssets.googleIcon,
                        label: 'Sign Up with Google',
                        onPressed: () {
                          // Handle Google sign-in
                        },
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
