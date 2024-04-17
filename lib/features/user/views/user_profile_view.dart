import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/views/camera_view.dart';
import 'package:splach/features/user/components/user_profile_header.dart';
import 'package:splach/features/user/controllers/user_profile_controller.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/gallery_edit_view.dart';
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
        title: controller.isCurrentUser ? 'Perfil' : controller.user.name,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(user: controller.user),
            const SizedBox(height: 16),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: controller.galleryImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final galleryImage = controller.galleryImages[index];
                    return Image.network(galleryImage.image);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getImage(context),
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
}
