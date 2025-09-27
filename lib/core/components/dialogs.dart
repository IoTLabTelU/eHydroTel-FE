import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

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
    title: Text(title, style: Theme.of(context).textTheme.titleMedium),
    content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (onCancel != null) onCancel();
        },
        child: Text(cancelText, style: dmSansNormalText(color: ColorValues.iotMainColor)),
      ),
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
