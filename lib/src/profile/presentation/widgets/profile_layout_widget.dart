import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydro_iot/res/assets.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/res/text_styles.dart';

class ProfileLayoutWidget extends StatelessWidget {
  final Widget? child;
  final String? namePage;
  final String? userName;
  final String? userEmail;
  final String? imgUrl;
  const ProfileLayoutWidget({
    super.key,
    this.child,
    this.namePage,
    this.userName,
    this.userEmail,
    this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    double stackingHeight = 6;
    double spaceHeight = MediaQuery.of(context).size.height / stackingHeight;

    return Stack(
      children: [
        ///Background
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / stackingHeight + 100,
          color: ColorValues.neutral300,
        ),
        Column(
          children: [
            ///Name Page
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / stackingHeight,
              child: Text(
                namePage ?? 'Name Page',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            /// CONTENT
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: ColorValues.neutral100,
                ),

                ///ini usernamenya bg
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    Text(userName ?? 'User Name', style: dmSansHeadText()),
                    SizedBox(height: 1.h),
                    Text(userEmail ?? 'User Email', style: dmSansNormalText()),
                    SizedBox(height: 10.h),

                    Expanded(
                      child: SizedBox(
                        width: double.infinity,

                        ///ini CHILD contentnya bg
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        ///STACKING
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: spaceHeight * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
              ),
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
                      image: DecorationImage(
                        image: AssetImage(imgUrl ?? ''),
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
          ],
        ),
      ],
    );
  }
}
