import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/common/home/widgets/nav_button_list.dart';
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
  bool isCollapsed = false;
  Timer? _collapseTimer;

  void _startCollapseTimer() {
    _collapseTimer?.cancel();
    _collapseTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isCollapsed = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.navigationShell.currentIndex;
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorValues.neutral100.withValues(alpha: 0.99),
        body: Stack(
          children: [
            Positioned.fill(child: widget.navigationShell),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              bottom: isCollapsed ? -heightQuery(context) * 0.15 : 0,
              left: 0,
              right: 0,
              child: bottomNav(context),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              bottom: 16,
              right: isCollapsed ? 16 : -widthQuery(context) * 0.15,
              child: FloatingActionButton(
                backgroundColor: ColorValues.iotMainColor,
                mini: true,
                onPressed: () {
                  setState(() {
                    isCollapsed = false;
                  });
                  _startCollapseTimer();
                },
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 8.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNav(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widthQuery(context) / 100 * 4.5,
        0,
        widthQuery(context) / 100 * 4.5,
        heightQuery(context) * 0.05,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        elevation: 6,
        child: Container(
          height: heightQuery(context) * 0.13,
          width: widthQuery(context),
          decoration: BoxDecoration(
            color: ColorValues.iotMainColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: -10,
                left: widthQuery(context) / 100 * 3,
                right: widthQuery(context) / 100 * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: navButtonList.map((data) {
                    return NavButtonWidget(
                      onPressed: (val) {
                        widget.navigationShell.goBranch(val);
                        setState(() {
                          currentIndex = val;
                          isCollapsed = false;
                        });
                        _startCollapseTimer();
                      },
                      icon: data['icon']!,
                      currentIndex: currentIndex,
                      index: navButtonList.indexOf(data),
                      text: data['text']!,
                    );
                  }).toList(),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.decelerate,
                top: 0,
                left: animatedPositioned(currentIndex),
                child: Column(
                  children: [
                    Container(
                      height: widthQuery(context) / 100 * 1.0,
                      width: widthQuery(context) / 100 * 12,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    ClipPath(
                      clipper: MyCustomClipper(context),
                      child: Container(
                        height: widthQuery(context) / 100 * 14,
                        width: widthQuery(context) / 100 * 12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorValues.whiteColor.withValues(alpha: 0.8),
                              ColorValues.whiteColor.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
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
        return widthQuery(context) / 100 * 7.8;
      case 1:
        return widthQuery(context) / 100 * 29;
      case 2:
        return widthQuery(context) / 100 * 50.5;
      case 3:
        return widthQuery(context) / 100 * 71.5;
      default:
        return 0;
    }
  }
}
