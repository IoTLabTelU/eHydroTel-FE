import '../../../../../../pkg.dart';

class PairingStepContentWidget extends StatelessWidget {
  const PairingStepContentWidget({super.key, required this.title, required this.description, required this.imageAsset});

  final String title;
  final Widget description;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: ColorValues.whiteColor,
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: ColorValues.neutral100),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(imageAsset, fit: BoxFit.cover),
          SizedBox(height: 16.h),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          description,
        ],
      ),
    );
  }
}
