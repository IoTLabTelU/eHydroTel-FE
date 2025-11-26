import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/common/home/widgets/nav_button_widget.dart';
import 'package:hydro_iot/src/notification/application/controllers/notification_controller.dart';

import '../../../pkg.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<Navbar> createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.navigationShell.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFCMAndRegister();
    });
  }

  Future<void> _initFCMAndRegister() async {
    final fcm = FcmHelper();
    await fcm.initializeFCM();
    final token = await fcm.waitForToken();
    if (token != null) {
      await ref.read(notificationControllerProvider.notifier).registerFcmToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorValues.neutral50,
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
