import '../../../../pkg.dart';

class CardLikeContainerWidget extends StatelessWidget {
  const CardLikeContainerWidget({super.key, required this.child, this.backgroundColor = Colors.white});

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: ColorValues.neutral100, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: child,
    );
  }
}
