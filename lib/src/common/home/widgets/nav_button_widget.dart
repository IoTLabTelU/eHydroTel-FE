import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class NavButtonWidget extends StatelessWidget {
  final Function(int) onPressed;
  final String icon;
  final int index;
  final int currentIndex;

  const NavButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed(index);
      },
      child: Container(
        height: widthQuery(context) / 100 * 13,
        width: widthQuery(context) / 100 * 17,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: (currentIndex == index) ? 1 : 0.2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                width: widthQuery(context) / 100 * 8,
                height: heightQuery(context) / 100 * 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
