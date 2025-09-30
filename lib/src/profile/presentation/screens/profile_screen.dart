import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/auth/presentation/screens/login_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/edit_profile.dart';
import 'package:hydro_iot/src/profile/presentation/screens/ssid.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_list.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_widget.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_layout_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String path = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authControllerProvider);

    List<Widget> pages = [const EditProfile(), const Ssid()];

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll(
            'Exception: ',
            '',
          );
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(
              context: context,
              title: 'Error',
              description: errorMessage,
            );
          }
        },
        loading: () async => await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const FancyLoadingDialog(title: 'Logging you out...'),
        ),
        data: (u) {
          if (u == null && context.mounted) {
            context.pop();
            context.pushReplacement('/${LoginScreen.path}');
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
          namePage: 'Profile',
          userName: data!.name,
          userEmail: data.email,
          imgUrl: 'assets/img/detail_image_1.jpg',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // Row(
              //   children: [
              //     Text('Profile Settings', style: dmSansHeadText()),
              //     SizedBox(width: 5.w),
              //     const Expanded(child: Divider(color: Colors.black)),
              //   ],
              // ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorValues.neutral300.withAlpha(150),
                ),
                child: Column(
                  children: List.generate(profileItemList.length, (index) {
                    final item = profileItemList[index];
                    return ProfileItemWidget(
                      title: item['title'] ?? '',
                      icon: item['icon'] ?? '',
                      onTap: () => showModalBottomSheet(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        useRootNavigator: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: pages[index],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              ///LOGOUT (FIXED)
              // Row(
              //   children: [
              //     Text('Logout', style: dmSansHeadText()),
              //     SizedBox(width: 5.w),
              //     const Expanded(child: Divider(color: Colors.black)),
              //   ],
              // ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorValues.neutral300.withAlpha(150),
                ),
                child: ProfileItemWidget(
                  title: 'Logout',
                  onTap: logout,
                  icon: IconAssets.logout,
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
