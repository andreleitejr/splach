import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/controllers/camera_gallery_controller.dart';

class GalleryImages extends StatelessWidget {
  final CameraGalleryController controller;
  const GalleryImages({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        itemCount: controller.galleryImages.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final galleryImage = controller.galleryImages[index];
          return GestureDetector(
            onTap: () {
              // image = galleryImage;
              Get.back(result: galleryImage);
            },
            child: Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: FileImage(
                    controller.galleryImages[index],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
