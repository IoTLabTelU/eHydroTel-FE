import 'package:hydro_iot/pkg.dart';

Widget alertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
    content: Text(content, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral600)),
    backgroundColor: ColorValues.whiteIoT,
    actions: [
      cancelButton(
        context: context,
        onPressed: () {
          context.pop();
          if (onCancel != null) onCancel();
        },
        backgroundColor: ColorValues.whiteColor,
      ),
      SizedBox(
        width: widthQuery(context) * 0.4,
        child: primaryButton(
          text: confirmText,
          onPressed: () {
            context.pop();
            if (onConfirm != null) onConfirm();
          },
          context: context,
          textColor: ColorValues.danger700,
          color: ColorValues.whiteColor,
        ),
      ),
    ],
  );
}

Widget infoDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'OK',
  VoidCallback? onConfirm,
}) {
  return AlertDialog(
    title: Text(title, style: Theme.of(context).textTheme.titleMedium),
    content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (onConfirm != null) onConfirm();
        },
        style: ElevatedButton.styleFrom(backgroundColor: ColorValues.iotMainColor),
        child: Text(confirmText, style: dmSansNormalText(color: ColorValues.whiteColor)),
      ),
    ],
  );
}
