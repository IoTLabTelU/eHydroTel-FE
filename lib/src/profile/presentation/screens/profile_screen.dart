import 'package:flutter/material.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/profile_layout_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String path = 'profile';

  @override
  Widget build(BuildContext context) {
    return const ProfileLayoutWidget(
      namePage: 'Profile',
      userName: 'Telyu Sigma',
      userEmail: 'telyusigma@telkomuniversity.ac.id',
      imgUrl: 'assets/img/detail_image_1.jpg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('data')],
      ),
    );

    // return Stack(
    //   children: [
    //     Column(
    //       children: [
    //         Container(
    //           // color: Colors.yellow,
    //           height: MediaQuery.of(context).size.height / stackingHeight,
    //         ),

    //         /// CONTENT
    //         Flexible(
    //           child: Container(
    //             width: double.infinity,
    //             decoration: const BoxDecoration(
    //               borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    //               color: Colors.green,
    //             ),
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   const SizedBox(height: 50),
    //                   for (int i = 0; i < 100; i++) Text("${i + 1}"),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),

    //     ///STACKING
    //     Column(
    //       children: [
    //         Container(
    //           alignment: Alignment.center,
    //           width: double.infinity,
    //           margin: const EdgeInsets.symmetric(horizontal: 10),
    //           height: spaceHeight * 2,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(20),
    //             color: Colors.transparent,
    //           ),
    //           child: Stack(
    //             alignment: Alignment.bottomRight,
    //             children: [
    //               Container(
    //                 width: 120,
    //                 height: 120,
    //                 decoration: BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   border: Border.all(
    //                     color: ColorValues.iotMainColor,
    //                     width: 3,
    //                   ),
    //                   image: const DecorationImage(
    //                     image: AssetImage('assets/img/detail_image_1.jpg'),
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),

    //               Padding(
    //                 padding: const EdgeInsets.only(bottom: 10),
    //                 child: CircleAvatar(
    //                   backgroundColor: ColorValues.iotMainColor,
    //                   radius: 15,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(5),
    //                     child: SvgPicture.asset(
    //                       IconAssets.pencilIcon,
    //                       colorFilter: ColorFilter.mode(
    //                         ColorValues.whiteColor,
    //                         BlendMode.srcIn,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),

    //     // Column(
    //     //   mainAxisAlignment: MainAxisAlignment.start,
    //     //   children: [
    //     //     SizedBox(
    //     //       height: MediaQuery.of(context).size.height / stackingHeight - 100,
    //     //     ),
    //     //     Container(
    //     //       margin: const EdgeInsets.symmetric(horizontal: 10),
    //     //       height: 300,
    //     //       decoration: BoxDecoration(
    //     //         borderRadius: BorderRadius.circular(20),
    //     //         color: Colors.purple,
    //     //       ),
    //     //     ),
    //     //   ],
    //     // ),
    //   ],
    // );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 10),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const SizedBox(height: 20),
    //       Padding(
    //         padding: const EdgeInsets.all(10),
    //   child: Text(
    //     'Profile',
    //     style: Theme.of(context).textTheme.titleLarge,
    //   ),
    // ),

    // SizedBox(
    //   width: double.infinity,
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(10),
    // child: Stack(
    //   alignment: Alignment.bottomRight,
    //   children: [
    //     Container(
    //       width: 120,
    //       height: 120,
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //         border: Border.all(
    //           color: ColorValues.iotMainColor,
    //           width: 3,
    //         ),
    //         image: const DecorationImage(
    //           image: AssetImage('assets/img/detail_image_1.jpg'),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),

    //     Padding(
    //       padding: const EdgeInsets.only(bottom: 10),
    //       child: CircleAvatar(
    //         backgroundColor: ColorValues.iotMainColor,
    //         radius: 15,
    //         child: Padding(
    //           padding: const EdgeInsets.all(5),
    //           child: SvgPicture.asset(
    //             IconAssets.pencilIcon,
    //             colorFilter: ColorFilter.mode(
    //               ColorValues.whiteColor,
    //               BlendMode.srcIn,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    //       ),
    // Text('User Name', style: dmSansHeadText()),
    // SizedBox(height: 1.h),
    // Text(
    //   'User Email@telkomuniversity.ac.id',
    //   style: dmSansNormalText(),
    // ),
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: 25.h),
    //       ...List.generate(
    //         profileItemList.length,
    //         (index) => ProfileItemWidget(
    //           title: '${profileItemList[index]['title']}',
    //           onPressed: () =>
    //               context.push('/${profileItemList[index]['path']}'),
    //           icon: '${profileItemList[index]['icon']}',
    //           currentIndex: 0,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
