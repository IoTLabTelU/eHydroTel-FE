import '../../../../pkg.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class ProfileItemWidget extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String icon;
  final Color iconColor;

  const ProfileItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Material(
          color: ColorValues.whiteColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(10),
                    child: VectorGraphic(
                      loader: AssetBytesLoader(icon),
                      colorFilter: const ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
                  const Spacer(),
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: VectorGraphic(
                      fit: BoxFit.scaleDown,
                      loader: AssetBytesLoader(IconAssets.moreInfo),
                      colorFilter: ColorFilter.mode(ColorValues.neutral500, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
