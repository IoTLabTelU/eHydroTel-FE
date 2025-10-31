import 'package:hydro_iot/src/profile/presentation/modals/edit_profile_modal.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import '../../../../pkg.dart';

class ProfileLayoutWidget extends StatelessWidget {
  final Widget? child;
  final String? namePage;
  final String? userName;
  final String? userEmail;
  final String? imgUrl;
  const ProfileLayoutWidget({super.key, this.child, this.namePage, this.userName, this.userEmail, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    double stackingHeight = 3.8;

    return Stack(
      children: [
        Container(
          width: widthQuery(context),
          height: heightQuery(context) / stackingHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(ImageAssets.accountBackground), fit: BoxFit.cover),
          ),
        ),
        Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / stackingHeight,
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        namePage ?? 'Account',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(59), color: Colors.transparent),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(59),
                          child: Material(
                            color: ColorValues.whiteColor,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  context: context,
                                  useSafeArea: true,
                                  builder: (context) =>
                                      EditProfileModal(imgUrl: imgUrl, name: userName ?? '', email: userEmail ?? ''),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(color: ColorValues.green50, shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(10),
                                      child: imgUrl != null
                                          ? ClipOval(
                                              child: Image.network(
                                                imgUrl!,
                                                fit: BoxFit.cover,
                                                cacheWidth: 60,
                                                cacheHeight: 60,
                                              ),
                                            )
                                          : const VectorGraphic(loader: AssetBytesLoader(IconAssets.grassAvatar)),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          userEmail ?? '',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: ColorValues.neutral500,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: VectorGraphic(
                                        fit: BoxFit.scaleDown,
                                        loader: AssetBytesLoader(IconAssets.moreInfo),
                                        colorFilter: ColorFilter.mode(ColorValues.neutral500, BlendMode.srcIn),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: ColorValues.whiteColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(child: child),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
