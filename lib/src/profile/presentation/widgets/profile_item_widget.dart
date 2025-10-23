import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/res/text_styles.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class ProfileItemWidget extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String icon;

  const ProfileItemWidget({super.key, required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: ColorValues.neutral100,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: dmSansNormalText()),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: VectorGraphic(
                      loader: AssetBytesLoader(icon),
                      colorFilter: const ColorFilter.mode(ColorValues.blackColor, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
