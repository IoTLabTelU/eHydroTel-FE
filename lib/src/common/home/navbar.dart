import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/common/home/widgets/nav_button_widget.dart';
import 'package:hydro_iot/utils/custom_clipper.dart';
import 'package:hydro_iot/utils/utils.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.navigationShell.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: widget.navigationShell),
            ),
            Positioned(bottom: -20, left: 0, right: 0, child: bottomNav(context)),
          ],
        ),
      ),
    );
  }

  Widget bottomNav(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(widthQuery(context) / 100 * 4.5, 0, widthQuery(context) / 100 * 4.5, 100),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        elevation: 6,
        child: Container(
          height: widthQuery(context) / 100 * 18,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(30)),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: widthQuery(context) / 100 * 3,
                right: widthQuery(context) / 100 * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavButtonWidget(
                      onPressed: (val) {
                        widget.navigationShell.goBranch(val);
                        setState(() {
                          currentIndex = val;
                        });
                      },
                      icon: IconAssets.dashboardIcon,
                      currentIndex: currentIndex,
                      index: 0,
                    ),
                    NavButtonWidget(
                      onPressed: (val) {
                        widget.navigationShell.goBranch(val);
                        setState(() {
                          currentIndex = val;
                        });
                      },
                      icon: IconAssets.deviceIcon,
                      currentIndex: currentIndex,
                      index: 1,
                    ),
                    NavButtonWidget(
                      onPressed: (val) {
                        widget.navigationShell.goBranch(val);
                        setState(() {
                          currentIndex = val;
                        });
                      },
                      icon: IconAssets.historyIcon,
                      currentIndex: currentIndex,
                      index: 2,
                    ),
                    NavButtonWidget(
                      onPressed: (val) {
                        widget.navigationShell.goBranch(val);
                        setState(() {
                          currentIndex = val;
                        });
                      },
                      icon: IconAssets.profileIcon,
                      currentIndex: currentIndex,
                      index: 3,
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.decelerate,
                top: 0,
                left: animatedPositioned(currentIndex),
                child: Column(
                  children: [
                    Container(
                      height: widthQuery(context) / 100 * 1.0,
                      width: widthQuery(context) / 100 * 12,
                      decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(10)),
                    ),
                    ClipPath(
                      clipper: MyCustomClipper(context),
                      child: Container(
                        height: widthQuery(context) / 100 * 15,
                        width: widthQuery(context) / 100 * 12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.teal.withOpacity(0.8), Colors.teal.withOpacity(0.5), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double animatedPositioned(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return widthQuery(context) / 100 * 8;
      case 1:
        return widthQuery(context) / 100 * 29;
      case 2:
        return widthQuery(context) / 100 * 51;
      case 3:
        return widthQuery(context) / 100 * 71;
      default:
        return 0;
    }
  }
}
