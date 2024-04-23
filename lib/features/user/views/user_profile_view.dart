import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/user/components/user_profile_header.dart';
import 'package:splach/features/user/controllers/user_profile_controller.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/gallery_edit_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/image_viewer.dart';
import 'package:splach/widgets/navigator_icon_button.dart';
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
    controller = Get.put(UserProfileController(widget.user));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        showLeading: false,
        title: controller.currentUser.nickname.toNickname(),
        actions: [
          NavigatorIconButton(
            icon: Icons.add_box_outlined,
            onPressed: () => _getImage(context),
          ),
          NavigatorIconButton(
            icon: Icons.menu,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: UserProfileHeader(user: controller.user),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  if (controller.isCurrentUser) ...[
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
                  ],
                ],
              )),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final galleryImage = controller.galleryImages[index];
                    return _galleryItem(galleryImage);
                  },
                  childCount: controller.galleryImages.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _galleryItem(Gallery galleryImage) {
    final imageSize = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => _showImageViewer(context, galleryImage.image),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: imageSize,
              minWidth: imageSize,
            ),
            child: Image.network(
              galleryImage.image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              galleryImage.description,
              style: ThemeTypography.regular14,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              galleryImage.createdAt.toMonthlyAndYearFormattedString(),
              style: ThemeTypography.regular12.apply(
                color: ThemeColors.grey3,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
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

  void _showImageViewer(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewer(
          images: [image],
        );
      },
    );
  }
}
