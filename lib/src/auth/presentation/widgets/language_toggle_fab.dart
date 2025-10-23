// language_toggle_fab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/providers/provider.dart';

/// FloatingActionButton-friendly language toggle.
/// - Tap untuk toggle English <-> Indonesia
/// - Animated knob with labels EN / ID
class LanguageToggleFAB extends ConsumerStatefulWidget {
  /// optional sizes if you want to customize
  final double width;
  final double height;
  final EdgeInsets padding;

  const LanguageToggleFAB({
    super.key,
    this.width = 120,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  });

  @override
  ConsumerState<LanguageToggleFAB> createState() => _LanguageToggleFABState();
}

class _LanguageToggleFABState extends ConsumerState<LanguageToggleFAB> with SingleTickerProviderStateMixin {
  static const Duration _animDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);
    final isEn = locale.languageCode == 'en';

    // Colors (you can override to use ColorValues from your theme)
    final bg = Colors.white;
    final activeColor = const Color(0xFF222222); // iotMainColor
    final inactiveTextColor = Colors.black87;

    return Material(
      // Card-like background to keep it consistent with FAB shadow
      color: bg,
      elevation: 0,
      borderRadius: BorderRadius.circular(widget.height / 2 + 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.height / 2),
        onTap: () {
          final newLocale = isEn ? const Locale('id') : const Locale('en');
          notifier.changeLanguage(newLocale);
        },
        child: Container(
          padding: widget.padding,
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Labels - EN (left) and ID (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'EN',
                      style: TextStyle(fontWeight: FontWeight.w600, color: isEn ? Colors.white : inactiveTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ID',
                      style: TextStyle(fontWeight: FontWeight.w600, color: isEn ? inactiveTextColor : Colors.white),
                    ),
                  ),
                ],
              ),

              // Animated knob
              AnimatedAlign(
                duration: _animDuration,
                curve: Curves.easeInOutCubic,
                alignment: isEn ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedContainer(
                    duration: _animDuration,
                    curve: Curves.easeInOut,
                    width: (widget.width / 2) - 12,
                    height: widget.height - 12,
                    decoration: BoxDecoration(
                      color: isEn ? activeColor : Colors.black,
                      borderRadius: BorderRadius.circular((widget.height - 12) / 2),
                      boxShadow: [
                        BoxShadow(
                          color: (isEn ? activeColor : Colors.black).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isEn ? 'EN' : 'ID',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
