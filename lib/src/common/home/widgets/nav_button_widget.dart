import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/common/home/widgets/nav_button_list.dart';

import '../../../../pkg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../devices/application/controllers/devices_controller.dart';

class NavButtonWidget extends ConsumerWidget {
  final Function(int) onPressed;
  final int currentIndex;

  const NavButtonWidget({super.key, required this.onPressed, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calibrationBadgeCount = ref
        .watch(devicesControllerProvider)
        .maybeWhen(data: (devices) => devices.where((d) => d.needsCalibration!).length, orElse: () => 0);
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(widthQuery(context) * 0.02),
      margin: EdgeInsets.symmetric(vertical: heightQuery(context) * 0.02, horizontal: widthQuery(context) * 0.03),
      decoration: BoxDecoration(color: ColorValues.neutral200, borderRadius: BorderRadius.circular(40)),
      child: GNav(
        gap: 8,
        activeColor: Colors.black,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.05, vertical: heightQuery(context) * 0.02),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: ColorValues.whiteColor,
        color: ColorValues.neutral500,
        tabs: navButtonList(context).map((item) {
          return GButton(
            icon: item['icon']!,
            text: item['text']!,
            leading: item['text'] == local.devices && calibrationBadgeCount > 0
                ? Badge(
                    label: Text(
                      calibrationBadgeCount.toString(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: ColorValues.danger600,
                    child: Icon(
                      item['icon'] as IconData,
                      color: currentIndex == navButtonList(context).indexOf(item) ? ColorValues.green500 : ColorValues.neutral500,
                    ),
                  )
                : null,
          );
        }).toList(),
        selectedIndex: currentIndex,
        onTabChange: onPressed,
      ),
    );
  }
}
