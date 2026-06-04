import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pkg.dart';
import '../src/common/no_connection_screen.dart';

class ConnectivityWrapper extends ConsumerWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityProvider);

    if (!isConnected) {
      return NoConnectionScreen(onRetry: () => ref.read(connectivityProvider.notifier).recheck());
    }

    return child;
  }
}
