import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/presentation/screens/login_screen.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_list.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_widget.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_layout_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String path = 'profile';

  @override
  Widget build(BuildContext context) {
    return ProfileLayoutWidget(
      namePage: 'Profile',
      userName: 'Telyu Sigma',
      userEmail: 'telyusigma@telkomuniversity.ac.id',
      imgUrl: 'assets/img/detail_image_1.jpg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Row(
            children: [
              Text('Profile Settings', style: dmSansHeadText()),
              SizedBox(width: 5.w),
              const Expanded(child: Divider(color: Colors.black)),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorValues.neutral300.withAlpha(150),
            ),
            child: Column(
              children: profileItemList
                  .map(
                    (item) => ProfileItemWidget(
                      title: item['title'] ?? '',
                      icon: item['icon'] ?? '',
                      onTap: () => context.push(item['path']!),
                    ),
                  )
                  .toList(),
            ),
          ),

          ///LOGOUT (FIXED)
          Row(
            children: [
              Text('Logout', style: dmSansHeadText()),
              SizedBox(width: 5.w),
              const Expanded(child: Divider(color: Colors.black)),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorValues.neutral300.withAlpha(150),
            ),
            child: ProfileItemWidget(
              title: 'Logout',
              onTap: () => context.pushReplacement('/${LoginScreen.path}'),
              icon: IconAssets.logout,
            ),
          ),
        ],
      ),
    );
  }
}
