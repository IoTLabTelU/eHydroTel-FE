import 'package:hydro_iot/src/common/home/widgets/nav_button_list.dart';

import '../../../../pkg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavButtonWidget extends StatelessWidget {
  final Function(int) onPressed;
  final int currentIndex;

  const NavButtonWidget({super.key, required this.onPressed, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widthQuery(context) * 0.02),
      margin: EdgeInsets.symmetric(vertical: heightQuery(context) * 0.02, horizontal: widthQuery(context) * 0.03),
      decoration: BoxDecoration(
        color: ColorValues.neutral200,
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: .1))],
        borderRadius: BorderRadius.circular(40),
      ),
      child: GNav(
        gap: 8,
        activeColor: Colors.black,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.05, vertical: heightQuery(context) * 0.02),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: ColorValues.whiteColor,
        color: ColorValues.neutral500,
        tabs: navButtonList.map((item) {
          return GButton(icon: item['icon']!, text: item['text']!);
        }).toList(),
        selectedIndex: currentIndex,
        onTabChange: onPressed,
      ),
    );
  }
}
