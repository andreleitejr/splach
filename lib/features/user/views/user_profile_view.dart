import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/user/components/gallery_item.dart';
import 'package:splach/features/user/components/user_profile_header.dart';
import 'package:splach/features/user/controllers/user_profile_controller.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/gallery_edit_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/navigator_icon_button.dart';
import 'package:splach/widgets/rating_stars.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class UserProfileView extends StatefulWidget {
  final User user;

  const UserProfileView({super.key, required this.user});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late UserProfileController controller;

  @override
  void initState() {
    controller = UserProfileController(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: TopNavigationBar(
            showLeading: !controller.user.isCurrentUser,
            title: controller.user.nickname.toNickname(),
            actions: [
              if (controller.user.isCurrentUser) ...[
                NavigatorIconButton(
                  icon: Icons.add_box_outlined,
                  onPressed: () => _getImage(context),
                ),
                NavigatorIconButton(
                  icon: Icons.menu,
                  onPressed: () {},
                ),
              ],
            ],
          ),
          body: SafeArea(
            child: Obx(() {
              if (controller.loading.isTrue) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: UserProfileHeader(user: controller.user),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (controller.user.isCurrentUser) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: FlatButton(
                              actionText: 'Edit Profile',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(height: 16),
                        ] else ...[
                          Obx(() {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: RatingStars(
                                score: controller.score.value,
                                onPressed: controller.score,
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          Obx(() {
                            print(
                                '################# ${controller.showRateButton.value}');
                            if (controller.showRateButton.isFalse) {
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: FlatButton(
                                  onPressed: () {
                                    controller.rate(widget.user.id!);
                                    Get.back();
                                  },
                                  actionText:
                                      'Rate ${widget.user.nickname.toNickname()}',
                                ),
                              ),
                            );
                          })
                        ],
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(() {
                      return StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: [
                          for (int index = 0;
                              index < controller.galleryImages.length;
                              index++) ...[
                            StaggeredGridTile.count(
                              crossAxisCellCount:
                                  buildCrossAxisCellCount(index),
                              mainAxisCellCount: buildMainAxisCellCount(index),
                              child: GalleryItem(
                                galleryImage: controller.galleryImages[index],
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  int buildCrossAxisCellCount(int index) {
    late int crossIndex;
    if (controller.galleryImages.length <= 1) {
      crossIndex = 4;
    } else if (controller.galleryImages.length <= 6) {
      crossIndex = 2;
    } else {
      crossIndex = getCrossAxisCellCount(index);
    }
    return crossIndex;
  }

  int buildMainAxisCellCount(int index) {
    late int mainIndex;
    if (controller.galleryImages.length == 1) {
      mainIndex = 4;
    } else if (controller.galleryImages.length <= 4) {
      mainIndex = 2;
    } else {
      mainIndex = getMainAxisCellCount(index);
    }
    return mainIndex;
  }

  int getCrossAxisCellCount(int index) {
    switch (index) {
      case 0:
        return 2;
      case 1:
        return 2;
      case 2:
        return 1;
      case 3:
        return 1;
      case 4:
        return 4;
      case 5:
        return 2;
      // case 6:
      //   return 2;
      // case 7:
      //   return 1;
      // case 8:
      //   return 1;
      // case 9:
      //   return 4;
      default:
        return 2;
    }
  }

  int getMainAxisCellCount(int index) {
    switch (index) {
      case 0:
        return 2;
      case 1:
        return 1;
      case 2:
        return 1;
      case 3:
        return 1;
      case 4:
        return 2;
      case 5:
        return 2;
      // case 6:
      //   return 1;
      // case 7:
      //   return 1;
      // case 8:
      //   return 1;
      // case 9:
      //   return 2;
      default:
        return 2;
    }
  }

  Future<void> _getImage(BuildContext context) async {
    final image = await Get.to(
      () => CameraGalleryView(
        image: controller.image.value,
      ),
    );
    if (image != null) {
      controller.image.value = image;
      Get.to(
        () => GalleryEditView(
          controller: controller,
        ),
      );
    }
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? ThemeColors.primary,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
