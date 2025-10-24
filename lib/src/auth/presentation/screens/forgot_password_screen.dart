import 'package:hydro_iot/src/auth/application/controllers/change_password_controller.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/forgot_password_content_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../pkg.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String path = 'forgot-password';

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<void>>(changePasswordControllerProvider, (_, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
          }
        },
      );
    });
    void sendCode() {
      if (emailController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
        return;
      }
      ref.read(changePasswordControllerProvider.notifier).changePasswordRequest(email: emailController.text);
      context.push('/verify-otp', extra: {'email': emailController.text});
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
            body: ForgotPasswordContentWidget(emailController: emailController, send: sendCode),
          ),
        ],
      ),
    );
  }
}
