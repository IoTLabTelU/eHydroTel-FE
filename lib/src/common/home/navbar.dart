import 'package:flutter/material.dart';
import 'package:hydro_iot/src/common/home/widgets/nav_button_widget.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        return;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: widget.navigationShell),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: NavButtonWidget(
                currentIndex: currentIndex,
                onPressed: (index) {
                  setState(() {
                    currentIndex = index;
                    widget.navigationShell.goBranch(index);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
