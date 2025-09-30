import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/login_with_password_controller.dart';
import 'package:hydro_iot/src/auth/application/controllers/register_with_password_controller.dart';
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
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<bool>>(registerWithPasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          if (context.mounted) {
            Toast().showErrorToast(context: context, title: local.error, description: err.toString());
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.creatingYourAccount),
          );
        },
        data: (response) {
          if (response && context.mounted) {
            Toast().showSuccessToast(context: context, title: local.success, description: local.registrationSuccessful);
            context.pushReplacement('/login');
          }
        },
      );
    });

    void register() {
      if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: local.fillAllFields);
        return;
      }
      ref
          .read(registerWithPasswordControllerProvider.notifier)
          .registerWithEmailPassword(nameController.text, emailController.text, passwordController.text);
    }

    void registerWithGoogle() {
      context.push('/login');
      ref.read(loginWithPasswordControllerProvider.notifier).loginWithGoogle();
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
                        local.registerTitle,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 20.h),
                      Text(local.registerSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
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
                            TextSpan(text: local.clickingRegister, style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to Terms of Service
                                },
                                child: Text(
                                  local.termsOfService,
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
                                  local.privacyPolicy,
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
                        child: primaryButton(text: local.registerTitle, onPressed: register, context: context),
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
                            child: Text(local.or, style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
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
                        label: local.signUpWithGoogle,
                        onPressed: registerWithGoogle,
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          local.alreadyHaveAccount,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: ColorValues.neutral400, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: secondaryButton(
                          text: local.signInTitle,
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
