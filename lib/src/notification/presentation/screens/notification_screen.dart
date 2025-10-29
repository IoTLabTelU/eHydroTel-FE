import 'package:hydro_iot/core/components/screen_header.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/notification/presentation/widgets/notification_card_widget.dart';
import 'package:hydro_iot/src/notification/presentation/widgets/notification_section_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../pkg.dart';
import '../widgets/section_list.dart';

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  static const String path = 'notification';

  @override
  ConsumerState<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends ConsumerState<NotificationCenterScreen> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final userProvider = ref.watch(authControllerProvider);
    return Skeletonizer(
      enabled: userProvider.isLoading,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: userProvider.when(
                data: (user) => ScreenHeader(
                  username: user!.name.split(' ')[0],
                  plantAsset: IconAssets.notification,
                  line1: local.heresYourLatest,
                  line2: '${local.updates} ',
                ),
                loading: () => const SizedBox.shrink(),
                error: (err, _) => Center(child: Text('${local.error} $err')),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            sliver: SliverAnimatedList(
              initialItemCount: notificationSections.length,
              itemBuilder: (ctx, idx, animation) {
                final String title = notificationSections[idx];
                return NotificationSection(
                  title: title,
                  notifications: const [
                    // Placeholder notifications for demonstration
                    NotificationCardWidget(
                      title: 'Notification Title 1',
                      body: 'This is the body of notification 1.',
                      time: '10:00 AM',
                    ),
                    NotificationCardWidget(
                      title: 'Notification Title 2',
                      body: 'This is the body of notification 2.',
                      time: '11:00 AM',
                    ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: heightQuery(context) * 0.15)),
        ],
      ),
    );
  }
}
