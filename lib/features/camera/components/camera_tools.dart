import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/controllers/camera_gallery_controller.dart';

class CameraTools extends StatelessWidget {
  final CameraGalleryController controller;

  const CameraTools({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _openGalleryButton(),
        _takePhotoButton(),
        _turnCameraButton(),
      ],
    );
  }

  Widget _openGalleryButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () async {
            await controller.pickImageFromGallery();
            if (controller.image != null) {
              Get.back(result: controller.image!);
            }
          },
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: FileImage(
                  controller.galleryImages.first,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _takePhotoButton() {
    return Center(
      child: TextButton(
        onPressed: () async {
          await controller.takePhoto();
          if (controller.image != null) {
            Get.back(result: controller.image!);
          }
        },
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 6,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Container(),
          ),
        ),
      ),
    );
  }

  Widget _turnCameraButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () async {
            await controller.toggleCameraLens();
            // setState(() {});
          },
          child: const Icon(
            Icons.change_circle_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
