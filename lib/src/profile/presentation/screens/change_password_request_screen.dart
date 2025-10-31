import 'package:hydro_iot/src/auth/application/controllers/change_password_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/change_password_request_content_widget.dart';

import '../../../../pkg.dart';

class ChangePasswordRequestScreen extends ConsumerStatefulWidget {
  const ChangePasswordRequestScreen({super.key, required this.email});

  final String email;
  static const String path = 'authed-change-password-request';

  @override
  ConsumerState<ChangePasswordRequestScreen> createState() => _ChangePasswordRequestScreenState();
}

class _ChangePasswordRequestScreenState extends ConsumerState<ChangePasswordRequestScreen> {
  TextEditingController get emailController => TextEditingController(text: widget.email);

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
      ref.read(changePasswordControllerProvider.notifier).changePasswordRequest(email: emailController.text);
      context.pushReplacement('/authed-verify-otp', extra: {'email': emailController.text});
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
            body: ChangePasswordRequestContentWidget(emailController: emailController, send: sendCode),
          ),
        ],
      ),
    );
  }
}
