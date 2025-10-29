import 'package:vector_graphics/vector_graphics.dart';

import '../../../../../pkg.dart';

class PairingStepHeaderWidget extends StatelessWidget {
  const PairingStepHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: ColorValues.whiteColor,
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: ColorValues.neutral100),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      // margin: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                local.getReadyToPair,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.w),
              const VectorGraphic(loader: AssetBytesLoader(IconAssets.checkTrue)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            local.makeSureEverythingIsReady,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
          ),
        ],
      ),
    );
  }
}
