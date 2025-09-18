import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydro_iot/res/res.dart';

Widget oAuthButtonWidget({
  required BuildContext context,
  required String assetName,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: ColorValues.neutral200),
      ),
    ),
    icon: SvgPicture.asset(assetName, height: 24, width: 24),
    label: Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.neutral700, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    onPressed: onPressed,
  );
}
