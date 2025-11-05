import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/login_with_password_controller.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/login_content_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

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
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<AuthResponse>>(loginWithPasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
            context.pop();
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.signingYouIn),
          );
        },
        data: (response) async {
          if (response.tokens != null && context.mounted) {
            final role = await Storage().readRole();
            if (role == 'ADMIN' && context.mounted) {
              context.pop();
              Toast().showErrorToast(context: context, title: local.error, description: local.accountNotSupported);
              return;
            }
            if (context.mounted) {
              context.pop();
              context.pushReplacement('/dashboard');
            }
          }
        },
      );
    });

    void login() {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
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
      child: Stack(
        children: [
          Container(
            height: heightQuery(context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.authBackground),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                decoration: const BoxDecoration(color: ColorValues.whiteColor, shape: BoxShape.circle),
                margin: EdgeInsets.only(left: 16.w),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: ColorValues.blackColor),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ),
            body: LoginContentWidget(emailController: emailController, passwordController: passwordController, login: login),
          ),
        ],
      ),
    );
  }
}
