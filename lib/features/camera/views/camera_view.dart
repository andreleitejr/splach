import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/components/camera_preview.dart';
import 'package:splach/features/camera/components/camera_tools.dart';
import 'package:splach/features/camera/components/gallery_images.dart';
import 'package:splach/features/camera/controllers/camera_gallery_controller.dart';

class CameraGalleryView extends StatefulWidget {
  final File? image;

  const CameraGalleryView({
    super.key,
    required this.image,
  });

  @override
  State<CameraGalleryView> createState() => _CameraGalleryViewState();
}

class _CameraGalleryViewState extends State<CameraGalleryView> {
  final cameraController = Get.put(CameraGalleryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _cameraPreview(),
            const SizedBox(height: 24),
            _galleryImages(),
            const SizedBox(height: 16),
            _cameraTools(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreview() {
    return Obx(
      () {
        if (cameraController.cameraController.value == null) {
          return Container();
        }
        return CameraImagePreview(
          controller: cameraController,
        );
      },
    );
  }

  Widget _galleryImages() {
    return Obx(() {
      if (cameraController.galleryImages.isEmpty) {
        return Container();
      }
      return GalleryImages(
        controller: cameraController,
      );
    });
  }

  Widget _cameraTools() {
    return Obx(() {
      if (cameraController.galleryImages.isEmpty) {
        return Container();
      }
      return CameraTools(
        controller: cameraController,
      );
    });
  }
}
