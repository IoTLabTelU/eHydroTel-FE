import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../pkg.dart';

class OtpPasswordContentWidget extends StatelessWidget {
  const OtpPasswordContentWidget({
    super.key,
    required this.verify,
    required this.email,
    required this.controllers,
    required this.resendCode,
  });
  final Function(List<TextEditingController?>) controllers;
  final String email;
  final VoidCallback verify;
  final VoidCallback resendCode;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.05, vertical: heightQuery(context) * 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(37.0)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                local.enterVerificationCode,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  text: local.check,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  children: [
                    TextSpan(
                      text: ' $email ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorValues.blueLink),
                    ),
                    TextSpan(text: local.digitCode, style: Theme.of(context).textTheme.bodyMedium?.copyWith()),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              OtpTextField(
                handleControllers: (a) {},
                alignment: Alignment.center,
                numberOfFields: 6,
                borderColor: ColorValues.neutral400,
                showFieldAsBox: true,
                fieldWidth: widthQuery(context) * 0.11,
                fieldHeight: heightQuery(context) * 0.08,
                cursorColor: ColorValues.blackColor,
                focusedBorderColor: ColorValues.blackColor,
                textStyle: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600),
                keyboardType: TextInputType.number,
                borderRadius: BorderRadius.circular(10.r),
                contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                margin: EdgeInsets.only(right: 5.w),
                fillColor: ColorValues.neutral50,
                filled: true,
                borderWidth: 1,
                onSubmit: (String verificationCode) {
                  verify();
                }, // end onSubmit
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: widthQuery(context) * 0.5,
                child: primaryButton(text: local.verifyCode, onPressed: verify, context: context),
              ),
              SizedBox(height: 40.h),
              Text(
                ' ${local.noCode} ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: resendCode,
                    child: Text(
                      local.resendCode,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                    ),
                  ),
                  Text(
                    ' ${local.or} ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Text(
                      local.changeEmail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blueLink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
