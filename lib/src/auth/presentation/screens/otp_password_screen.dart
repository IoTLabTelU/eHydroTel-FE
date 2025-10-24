import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/auth/application/controllers/change_password_controller.dart';
import 'package:hydro_iot/src/auth/presentation/widgets/otp_password_content_widget.dart';

import '../../../../pkg.dart';

class OtpPasswordScreen extends ConsumerStatefulWidget {
  const OtpPasswordScreen({super.key, required this.email});

  static const String path = 'verify-otp';
  final String email;

  @override
  ConsumerState<OtpPasswordScreen> createState() => _OtpPasswordScreenState();
}

class _OtpPasswordScreenState extends ConsumerState<OtpPasswordScreen> {
  List<TextEditingController?> otpControllers = [];
  String get otpCode => otpControllers.map((e) => e == null ? '' : e.text).toList().join();
  void otpController(List<TextEditingController?> controllers) {
    otpControllers = controllers;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<void>>(changePasswordControllerProvider, (_, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(context: context, title: AppLocalizations.of(context)!.error, description: errorMessage);
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.verifyingCode),
          );
        },
        data: (response) {
          if (context.mounted) {
            context.pop();
          }
        },
      );
    });
    void verifyCode() async {
      if (otpCode.length < 6 && otpCode.contains('')) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
        return;
      }
      try {
        final data = await ref.read(changePasswordControllerProvider.notifier).verifyOtp(email: widget.email, otp: otpCode);
        if (data != null && context.mounted) {
          context.push('/change-password', extra: {'email': widget.email, 'resetToken': data.resetToken});
        }
      } catch (e) {
        final errorMessage = (e as Exception).toString().replaceAll('Exception: ', '');
        if (context.mounted) {
          Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
        }
      }
    }

    void resendCode() {
      ref.read(changePasswordControllerProvider.notifier).changePasswordRequest(email: widget.email);
      Toast().showSuccessToast(context: context, title: local.success, description: local.otpResent);
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
            body: OtpPasswordContentWidget(
              email: widget.email,
              verify: verifyCode,
              controllers: otpController,
              resendCode: resendCode,
            ),
          ),
        ],
      ),
    );
  }
}
