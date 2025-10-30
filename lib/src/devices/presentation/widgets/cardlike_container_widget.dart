import '../../../../pkg.dart';

class CardLikeContainerWidget extends StatelessWidget {
  const CardLikeContainerWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: ColorValues.neutral100, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: child,
    );
  }
}
