import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/profile/presentation/modals/crop_cycle_history_modal.dart';
import 'package:hydro_iot/src/profile/presentation/modals/privacy_policy_modal.dart';
import 'package:hydro_iot/src/profile/presentation/modals/switch_language_modal.dart';
import 'package:hydro_iot/src/profile/presentation/modals/terms_conditions_modal.dart';
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

    List<Widget> pages = [const CropCycleHistoryModal(), const SizedBox(), const SwitchLanguageModal()];
    List<Widget> legalPages = [const TermsConditionsModal(), const PrivacyPolicyModal()];

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            if (Navigator.canPop(context)) context.pop();
            Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
          }
        },
        loading: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => FancyLoadingDialog(title: local.loggingYouOut),
        ),
        data: (u) {
          if (u == null && context.mounted) {
            context.pop();
          }
        },
      );
    });
    void logout() async {
      await showAdaptiveDialog(
        context: context,
        builder: (_) {
          return alertDialog(
            context: context,
            title: local.logout,
            content: local.logoutConfirmation,
            confirmText: local.logout,
            onConfirm: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
          );
        },
      );
    }

    return userData.when(
      data: (data) {
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            return await ref.refresh(authControllerProvider.future);
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: ProfileLayoutWidget(
                  namePage: local.account,
                  userName: data!.name,
                  userEmail: data.email,
                  imgUrl: null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          local.settings,
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
                              onTap: () {
                                if (index == 1) {
                                  context.push('/authed-change-password-request', extra: {'email': data.email});
                                } else {
                                  showModalBottomSheet(
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    context: context,
                                    useSafeArea: true,
                                    builder: (context) => pages[index],
                                  );
                                }
                              },
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          'Legal',
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
                                  child: legalPages[index],
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
              ),
            ],
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
