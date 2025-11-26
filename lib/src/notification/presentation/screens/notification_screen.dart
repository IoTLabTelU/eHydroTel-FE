import 'package:hydro_iot/core/components/screen_header.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/notification/application/controllers/notification_controller.dart';
import 'package:hydro_iot/src/notification/application/controllers/notification_history_controller.dart';
import 'package:hydro_iot/src/notification/domain/entities/notification_history_entity.dart';
import 'package:hydro_iot/src/notification/presentation/widgets/notification_card_widget.dart';
import 'package:hydro_iot/src/notification/presentation/widgets/notification_section_widget.dart';
import 'package:intl/intl.dart';
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
    final notificationsAsync = ref.watch(notificationHistoryControllerProvider);

    return Skeletonizer(
      enabled: userProvider.isLoading || notificationsAsync.isLoading,
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          return await ref.refresh(notificationHistoryControllerProvider.future);
        },
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            // ----- HEADER -----
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

            // ----- NOTIFICATIONS -----
            notificationsAsync.when(
              loading: () => _buildLoadingSections(),
              error: (err, _) => SliverToBoxAdapter(
                child: Padding(padding: const EdgeInsets.all(16.0), child: Text('${local.error}: $err')),
              ),
              data: (notifications) =>
                  _buildFilteredSections(context, notifications, local, (NotificationHistoryEntity n) async {
                    await ref.read(notificationControllerProvider.notifier).softDeleteNotification(n.id);
                    ref.invalidate(notificationHistoryControllerProvider);
                    ref.read(notificationHistoryControllerProvider.notifier).fetchNotifications();
                  }),
            ),

            SliverToBoxAdapter(child: SizedBox(height: heightQuery(context) * 0.15)),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ONLY SHOW SECTIONS THAT HAVE NOTIFICATIONS
  // ----------------------------------------------------------
  Widget _buildFilteredSections(
    BuildContext context,
    List<NotificationHistoryEntity> notifications,
    AppLocalizations local,
    Function onDelete,
  ) {
    final List<Widget> sectionWidgets = [];

    for (var section in notificationSections(context)) {
      final title = section['title'];
      final start = section['start'];
      final end = section['end'];

      // Filter notifikasi yang masuk range section
      final filtered = notifications.where((n) => n.createdAt.isAfter(start) && n.createdAt.isBefore(end));

      if (filtered.isNotEmpty) {
        // Build cards
        final items = filtered.map((n) {
          return NotificationCardWidget(
            title: n.title,
            body: n.body,
            time: DateFormat.jm().format(n.createdAt),
            onDelete: () => onDelete(n),
          );
        }).toList();

        sectionWidgets.add(NotificationSection(title: title, notifications: items));
      }
    }

    // Jika semua section kosong → tampilkan "No notifications"
    if (sectionWidgets.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(local.noNotifications, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: sectionWidgets[index],
        ),
        childCount: sectionWidgets.length,
      ),
    );
  }

  // ----------------------------------------------------------
  // SKELETON WHILE LOADING
  // ----------------------------------------------------------
  Widget _buildLoadingSections() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, idx) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            children: List.generate(
              3,
              (i) => Skeleton.leaf(
                enabled: true,
                child: NotificationCardWidget(title: 'Loading...', body: 'Loading...', time: '--:--', onDelete: () {}),
              ),
            ),
          ),
        ),
        childCount: 3,
      ),
    );
  }
}
