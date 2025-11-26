import 'package:hydro_iot/pkg.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18, color: ColorValues.neutral500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(local.disclaimerText, style: const TextStyle(color: ColorValues.neutral600)),
        ),
      ],
    );
  }
}
