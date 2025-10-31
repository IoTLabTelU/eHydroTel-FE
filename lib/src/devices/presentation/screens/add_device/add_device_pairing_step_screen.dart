import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/pairing_step_content_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../pkg.dart';
import '../../widgets/pairing_step_header_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDevicePairingStepScreen extends ConsumerStatefulWidget {
  const AddDevicePairingStepScreen({
    super.key,
    required this.serialNumber,
    required this.deviceName,
    required this.deviceDescription,
  });

  final String serialNumber;
  final String deviceName;
  final String deviceDescription;

  static const String path = 'pairing';

  @override
  ConsumerState<AddDevicePairingStepScreen> createState() => _AddDevicePairingStepScreenState();
}

class _AddDevicePairingStepScreenState extends ConsumerState<AddDevicePairingStepScreen> {
  PageController pageController = PageController();
  PageController buttonPageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    buttonPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue>(devicesControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          Toast().showSuccessToast(context: context, title: local.success, description: local.deviceAddedSuccessfully);
          context.pop();
          context.pop();
        },
        error: (err, _) {
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(context: context, title: local.error, description: err.toString());
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.registeringYourDevice),
          );
        },
      );
    });

    void registerDevice() {
      if (widget.deviceName.isEmpty || widget.serialNumber.isEmpty) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
        return;
      }

      ref
          .read(devicesControllerProvider.notifier)
          .registerDevice(name: widget.deviceName, description: widget.deviceDescription, serialNumber: widget.serialNumber);
    }

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                onPressed: () async {
                  await showAdaptiveDialog(
                    context: context,
                    builder: (_) {
                      return alertDialog(
                        context: context,
                        title: local.discardYourEntries,
                        content: local.anyUnsavedEntriesWillBeLost,
                        confirmText: local.discardEntries,
                        onConfirm: () async {
                          context.pop();
                          context.pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            title: Text(
              local.newDevice,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(2);
                  },
                  child: Text(
                    local.skip,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: ColorValues.neutral500, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 18.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const PairingStepHeaderWidget(),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: heightQuery(context) * 0.3,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        buttonPageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      children: [
                        PairingStepContentWidget(
                          title: local.turnOnYourIoTDevice,
                          description: Text(
                            local.makeSureYourDeviceSwitchedOn,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
                            textAlign: TextAlign.center,
                          ),
                          imageAsset: ImageAssets.pairStep1,
                        ),
                        PairingStepContentWidget(
                          title: local.connectToDeviceWifi,
                          description: RichText(
                            text: TextSpan(
                              text: local.openYourPhonesWifi,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
                              children: [
                                TextSpan(
                                  text: ' "${widget.serialNumber}"',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorValues.blueProgress,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          imageAsset: ImageAssets.pairStep2,
                        ),
                        PairingStepContentWidget(
                          title: local.finishSetupInBrowser,
                          description: Text(
                            local.youllBeRedirected,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
                            textAlign: TextAlign.center,
                          ),
                          imageAsset: ImageAssets.pairStep3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      activeDotColor: ColorValues.green600,
                      dotColor: ColorValues.neutral300,
                    ),
                  ),
                  SizedBox(height: heightQuery(context) * 0.3),
                  SizedBox(
                    height: heightQuery(context) * 0.1,
                    child: PageView(
                      controller: buttonPageController,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: primaryButton(
                                text: local.continues,
                                onPressed: () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  buttonPageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                context: context,
                                color: ColorValues.green500,
                                textColor: ColorValues.green900,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: secondaryButton(
                                text: local.back,
                                context: context,
                                onPressed: () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                color: ColorValues.neutral200,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 5,
                              child: primaryButton(
                                text: local.continues,
                                onPressed: () {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  buttonPageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                context: context,
                                color: ColorValues.green500,
                                textColor: ColorValues.green900,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: secondaryButton(
                                text: local.back,
                                context: context,
                                onPressed: () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                color: ColorValues.neutral200,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              flex: 5,
                              child: primaryButton(
                                text: 'Finish',
                                onPressed: registerDevice,
                                context: context,
                                color: ColorValues.green500,
                                textColor: ColorValues.green900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
