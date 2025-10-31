import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/dashboard/application/providers/filter_devices_providers.dart';
import '../../pkg.dart';

import '../../src/dashboard/presentation/widgets/status_filter_overlay_widget.dart';

class FilterButtonWithOverlay extends ConsumerStatefulWidget {
  const FilterButtonWithOverlay({super.key});

  @override
  ConsumerState<FilterButtonWithOverlay> createState() => _FilterButtonWithOverlayState();
}

class _FilterButtonWithOverlayState extends ConsumerState<FilterButtonWithOverlay> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideOverlay,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              width: widthQuery(context) * 0.7,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(-widthQuery(context) * 0.5, 50),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return StatusFilterPopup(
                      onStatusSelected: (status) {
                        ref.read(filterDevicesProvider.notifier).setDeviceStatus(status);
                        setState(() {});
                      },
                      selectedStatus: ref.watch(filterDevicesProvider),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: 40.w,
        height: 40.h,
        child: filterButton(
          onPressed: () {
            if (_overlayEntry == null) {
              _showOverlay();
            } else {
              _hideOverlay();
            }
          },
          context: context,
        ),
      ),
    );
  }
}
