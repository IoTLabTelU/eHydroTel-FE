import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/login_with_password_controller.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/auth_appbar_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

import '../widgets/oauth_button_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String path = 'login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthResponse>>(loginWithPasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          if (context.mounted) {
            Toast().showErrorToast(context: context, title: err.toString());
          }
        },
        data: (response) {
          if (response.tokens != null && context.mounted) {
            context.pushReplacement('/dashboard');
          }
        },
      );
    });

    final loginState = ref.watch(loginWithPasswordControllerProvider);

    void login() {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: 'Please fill in all fields');
        return;
      }
      ref
          .read(loginWithPasswordControllerProvider.notifier)
          .loginWithEmailPassword(emailController.text, passwordController.text);
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: ColorValues.neutral100.withValues(alpha: 0.99),
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
                        'SIGN IN',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Welcome back! Please sign in to continue.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
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
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
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
                      loginState.isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : SizedBox(
                              width: double.infinity,
                              child: primaryButton(text: 'LOGIN', onPressed: login, context: context),
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
                        label: 'Sign In with Google',
                        onPressed: () {
                          // Handle Google sign-in
                        },
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
