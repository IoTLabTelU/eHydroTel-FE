import '../../../../pkg.dart';

class ChangePasswordContentWidget extends StatelessWidget {
  const ChangePasswordContentWidget({
    super.key,
    required this.newPasswordController,
    required this.newConfirmController,
    required this.reset,
  });

  final TextEditingController newPasswordController;
  final TextEditingController newConfirmController;
  final VoidCallback reset;

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
                local.setNewPassword,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                local.createNewPassword,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              TextFormFieldComponent(
                label: 'New Password',
                controller: newPasswordController,
                hintText: 'Enter your new password',
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              TextFormFieldComponent(
                label: 'Confirm Password',
                controller: newConfirmController,
                hintText: 'Confirm your new password',
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: widthQuery(context) * 0.5,
                child: primaryButton(text: local.verifyCode, onPressed: reset, context: context),
              ),
              SizedBox(height: 40.h),
              Text(
                local.makeSureItsSomething,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
