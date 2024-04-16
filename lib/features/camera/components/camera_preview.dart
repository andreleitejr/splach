import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/camera/controllers/camera_gallery_controller.dart';

class CameraImagePreview extends StatelessWidget {
  final CameraGalleryController controller;

  const CameraImagePreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: CameraPreview(
          controller.cameraController.value!,
        ),
      ),
    );
  }
}
