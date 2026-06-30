import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/application/providers/calibration_provider.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/cardlike_container_widget.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../../pkg.dart';
import '../../application/controllers/devices_controller.dart';

class StartCalibrationScreen extends ConsumerWidget {
  static const String path = 'start-calibration';
  final String serial;
  const StartCalibrationScreen({super.key, required this.serial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorValues.neutral50,
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
          title: Text(local.deviceCalibration, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CardLikeContainerWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(local.getReadyToCalibrate, style: Theme.of(context).textTheme.titleMedium),
                      Text(local.followGuidedSteps, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CardLikeContainerWidget(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(local.getFamiliarwithSensor, style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          local.youUseBothDuringCalibration,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
                        ),
                        const SizedBox(height: 12),
                        CardLikeContainerWidget(
                          backgroundColor: ColorValues.green400,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                local.phSensor,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorValues.green900),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: AspectRatio(
                                  aspectRatio: 5,
                                  child: Image.asset(ImageAssets.phStart, alignment: Alignment.centerRight, fit: BoxFit.contain),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        CardLikeContainerWidget(
                          backgroundColor: ColorValues.green400,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                local.ppmSensor,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorValues.green900),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: AspectRatio(
                                  aspectRatio: 5,
                                  child: Image.asset(ImageAssets.ppmStart, alignment: Alignment.centerRight, fit: BoxFit.contain),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      child: CardLikeContainerWidget(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(local.estimatedTotalTime, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: ColorValues.neutral500)),
                            const SizedBox(height: 4),
                            Consumer(
                              builder: (context, ref, _) {
                                final estimate = ref.watch(calibrationEstimatedTotalMinProvider);
                                final minutesText = estimate.maybeWhen(data: (min) => min.toString(), orElse: () => '--');
                                return RichText(
                                  text: TextSpan(
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorValues.blackColor),
                                    children: [
                                      TextSpan(
                                        text: minutesText,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorValues.blackColor),
                                      ),
                                      TextSpan(
                                        text: ' ${local.minutes}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: ColorValues.neutral500),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: CardLikeContainerWidget(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const VectorGraphic(loader: AssetBytesLoader(IconAssets.info), width: 26, height: 26),
                            const SizedBox(height: 10),
                            Text(local.keepTheDevicePoweredOn, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: primaryButton(
                    onPressed: () async {
                      final result = await context.push('/calibration-steps', extra: {'serialNumber': serial});
                      if (result == true) {
                        ref.invalidate(devicesControllerProvider);
                      }
                    },
                    context: context,
                    text: local.startCalibration,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
