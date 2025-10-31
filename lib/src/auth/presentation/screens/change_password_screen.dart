import 'package:hydro_iot/src/auth/application/controllers/change_password_controller.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/change_password_content_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../pkg.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key, required this.email, required this.resetToken});

  static const String path = 'change-password';
  final String email;
  final String resetToken;

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<void>>(changePasswordControllerProvider, (_, next) {
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
            builder: (context) => FancyLoadingDialog(title: local.resettingPassword),
          );
        },
        data: (response) {
          if (context.mounted) {
            context.pop();
            context.pushReplacement('/login');
            Toast().showSuccessToast(context: context, title: local.success, description: local.passwordResetSuccessful);
          }
        },
      );
    });
    void resetPassword() {
      if (newPasswordController.text.isEmpty || newConfirmController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
        return;
      }
      if (newPasswordController.text != newConfirmController.text) {
        Toast().showErrorToast(context: context, title: local.error, description: local.passwordsDoNotMatch);
        return;
      }
      ref
          .read(changePasswordControllerProvider.notifier)
          .resetPassword(email: widget.email, newPassword: newPasswordController.text, resetToken: widget.resetToken);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            body: ChangePasswordContentWidget(
              newPasswordController: newPasswordController,
              newConfirmController: newConfirmController,
              reset: resetPassword,
            ),
          ),
        ],
      ),
    );
  }
}
