import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class NavButtonWidget extends StatelessWidget {
  final Function(int) onPressed;
  final String icon;
  final int index;
  final int currentIndex;
  final String text;

  const NavButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        height: currentIndex == index ? widthQuery(context) / 100 * 18 : widthQuery(context) / 100 * 13,
        width: widthQuery(context) / 100 * 18,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: (currentIndex == index) ? 1 : 0.4,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                width: widthQuery(context) / 100 * 5,
                height: heightQuery(context) / 100 * 5,
              ),
            ),
            if (currentIndex == index) const SizedBox(height: 5),
            if (currentIndex == index)
              Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.whiteColor)),
          ],
        ),
      ),
    );
  }
}
