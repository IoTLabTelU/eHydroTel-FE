import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/profile/presentation/modals/switch_language_modal.dart';
import 'package:hydro_iot/src/profile/presentation/screens/edit_profile.dart';
import 'package:hydro_iot/src/profile/presentation/screens/ssid.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_list.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_widget.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_layout_widget.dart';

import '../../../../pkg.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String path = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = AppLocalizations.of(context)!;
    final userData = ref.watch(authControllerProvider);

    List<Widget> pages = [const EditProfile(), const Ssid(), const SwitchLanguageModal()];

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(context: context, title: 'Error', description: errorMessage);
          }
        },
        loading: () async => await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const FancyLoadingDialog(title: 'Logging you out...'),
        ),
        data: (u) {
          if (u == null && context.mounted) {
            context.pop();
          }
        },
      );
    });
    void logout() async {
      await ref.read(authControllerProvider.notifier).logout();
    }

    return userData.when(
      data: (data) {
        return ProfileLayoutWidget(
          namePage: local.account,
          userName: data!.name,
          userEmail: data.email,
          imgUrl: null,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: ColorValues.neutral200),
                    color: ColorValues.whiteColor,
                  ),
                  child: Column(
                    children: List.generate(settingsItemList(context).length, (index) {
                      final item = settingsItemList(context)[index];
                      return ProfileItemWidget(
                        title: item['title'] ?? '',
                        icon: item['icon'] ?? '',
                        iconColor: item['iconColor'] ?? ColorValues.neutral200,
                        onTap: () => showModalBottomSheet(
                          useRootNavigator: true,
                          isScrollControlled: true,
                          context: context,
                          useSafeArea: true,
                          builder: (context) => pages[index],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text('Legal', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 5.h),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: ColorValues.neutral200),
                    color: ColorValues.whiteColor,
                  ),
                  child: Column(
                    children: List.generate(legalItemList(context).length, (index) {
                      final item = legalItemList(context)[index];
                      return ProfileItemWidget(
                        title: item['title'] ?? '',
                        icon: item['icon'] ?? '',
                        iconColor: item['iconColor'] ?? ColorValues.neutral200,
                        onTap: () => showModalBottomSheet(
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                          useRootNavigator: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: pages[index],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: ColorValues.neutral200),
                    color: ColorValues.whiteColor,
                  ),
                  child: ProfileItemWidget(
                    title: local.logout,
                    onTap: logout,
                    icon: IconAssets.logout,
                    iconColor: hexColorize('#FFBB3D'),
                  ),
                ),
                SizedBox(height: heightQuery(context) * 0.2),
              ],
            ),
          ),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (err, _) {
        return Center(child: Text('Error: $err'));
      },
    );
  }
}
