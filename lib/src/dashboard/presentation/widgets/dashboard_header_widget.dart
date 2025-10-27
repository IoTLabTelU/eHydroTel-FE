import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import '../../../../pkg.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${local.welcome} $username,',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(local.letsgrow, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(local.amazing, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(width: widthQuery(context) * 0.02),
                const Skeleton.shade(
                  child: VectorGraphic(
                    loader: AssetBytesLoader(IconAssets.plant),
                    colorFilter: ColorFilter.mode(ColorValues.green500, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
