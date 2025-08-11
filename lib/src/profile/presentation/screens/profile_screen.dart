import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_iot/res/assets.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/res/text_styles.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_list.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String path = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorValues.iotMainColor,
                            width: 3,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/img/detail_image_1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          backgroundColor: ColorValues.iotMainColor,
                          radius: 15,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SvgPicture.asset(
                              IconAssets.pencilIcon,
                              colorFilter: ColorFilter.mode(
                                ColorValues.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text('User Name', style: dmSansHeadText()),
                SizedBox(height: 1.h),
                Text(
                  'User Email@telkomuniversity.ac.id',
                  style: dmSansNormalText(),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          ...List.generate(
            profileItemList.length,
            (index) => ProfileItemWidget(
              title: '${profileItemList[index]['title']}',
              onPressed: () =>
                  context.push('/${profileItemList[index]['path']}'),
              icon: '${profileItemList[index]['icon']}',
              currentIndex: 0,
            ),
          ),
        ],
      ),
    );
  }
}
