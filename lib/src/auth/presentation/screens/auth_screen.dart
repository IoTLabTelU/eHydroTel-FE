import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/login_with_password_controller.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/auth_content_widget.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/language_toggle_fab.dart';
import 'package:hydro_iot/utils/utils.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  static const String path = 'auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<AuthResponse>>(loginWithPasswordControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.signingYouIn),
          );
        },
        data: (response) {
          if (response.tokens != null && context.mounted) {
            context.pop();
            context.pushReplacement('/dashboard');
          }
        },
      );
    });

    void loginWithGoogle() {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        ref.read(loginWithPasswordControllerProvider.notifier).loginWithGoogle();
      } else {
        Toast().showErrorToast(context: context, title: local.error, description: local.googleSignInNotSupported);
      }
    }

    return Stack(
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
          body: authContentWidget(
            context: context,
            loginWithGoogle: loginWithGoogle,
            login: () {
              context.push('/login');
            },
            register: () {
              context.push('/register');
            },
          ),
          floatingActionButton: LanguageToggleFAB(width: widthQuery(context) * 0.3, height: heightQuery(context) * 0.065),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        ),
      ],
    );
  }
}
