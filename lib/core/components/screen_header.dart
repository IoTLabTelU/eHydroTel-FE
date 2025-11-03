import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import '../../pkg.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.username,
    required this.plantAsset,
    required this.line1,
    required this.line2,
  });

  final String username;
  final String plantAsset;
  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${local.welcome} $username,',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(line2, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(width: widthQuery(context) * 0.02),
                  Skeleton.shade(
                    child: VectorGraphic(
                      loader: AssetBytesLoader(plantAsset),
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(ColorValues.green500, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
