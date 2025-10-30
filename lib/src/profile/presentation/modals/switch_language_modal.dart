import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/cardlike_container_widget.dart';

import '../../../../pkg.dart';

class SwitchLanguageModal extends ConsumerStatefulWidget {
  const SwitchLanguageModal({super.key});

  @override
  ConsumerState<SwitchLanguageModal> createState() => _SwitchLanguageModalState();
}

class _SwitchLanguageModalState extends ConsumerState<SwitchLanguageModal> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          decoration: BoxDecoration(
            color: ColorValues.whiteColor,
            shape: BoxShape.circle,
            border: Border.all(color: ColorValues.neutral200),
          ),
          margin: EdgeInsets.only(left: 16.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorValues.blackColor),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        title: Text(
          local.switchLanguage,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: CardLikeContainerWidget(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  ref.read(localeProvider.notifier).changeLanguage(const Locale('en'));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'English (US)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    locale.languageCode == 'en'
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Image.asset(ImageAssets.multipleChoose, width: 16, height: 16),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  ref.read(localeProvider.notifier).changeLanguage(const Locale('id'));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bahasa Indonesia',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    locale.languageCode == 'id'
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Image.asset(ImageAssets.multipleChoose, width: 16, height: 16),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
