import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydro_iot/res/assets.dart';
import 'package:hydro_iot/res/colors.dart';

class ProfileLayoutWidget extends StatelessWidget {
  const ProfileLayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double stackingHeight = 6;
    double spaceHeight = MediaQuery.of(context).size.height / stackingHeight;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              // color: Colors.yellow,
              height: MediaQuery.of(context).size.height / stackingHeight,
            ),

            /// CONTENT
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: Colors.green,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      for (int i = 0; i < 100; i++) Text("${i + 1}"),
                    ],
                  ),
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
          ],
        ),

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SizedBox(
        //       height: MediaQuery.of(context).size.height / stackingHeight - 100,
        //     ),
        //     Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 10),
        //       height: 300,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20),
        //         color: Colors.purple,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
