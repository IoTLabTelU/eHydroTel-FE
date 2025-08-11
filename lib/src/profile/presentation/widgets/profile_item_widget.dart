import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/res/text_styles.dart';

class ProfileItemWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final String icon;
  final int currentIndex;

  const ProfileItemWidget({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            color: ColorValues.neutral300,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorValues.neutral100,
                    child: SvgPicture.asset(icon),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    title,
                    style: dmSansNormalText(size: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
