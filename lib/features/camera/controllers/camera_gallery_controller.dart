import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/services/image_service.dart';

class CameraGalleryController extends GetxController {
  File? image;

  final _imageService = CameraService();
  final galleryImages = <File>[].obs;

  final cameraController = Rx<CameraController?>(null);
  var cameras = <CameraDescription>[];

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeCamera();
    _requestAssets();
  }

  Future<void> initializeCamera() async {
    await _imageService.initializeCamera();
    cameraController.value = _imageService.getController();
    cameras = _imageService.cameras;
  }

  Future<void> takePhoto() async {
    final file = await _imageService.takePhoto();

    if (file != null) {
      image = file;
    }
  }

  Future<void> _initCamera(CameraDescription description) async {
    cameraController.value =
        CameraController(description, ResolutionPreset.medium);

    try {
      await cameraController.value!.initialize();
    } catch (e) {
      debugPrint('Initializing Camera after toggle error: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final file = await _imageService.pickImageFromGallery();

    if (file != null) {
      image = file;
    }
  }

  Future<void> _requestAssets() async {
    final files = await _imageService.requestAssets();
    if (files != null) {
      galleryImages.value = files;
    }
  }

  Future<void> toggleCameraLens() async {
    final currentLensDirection =
        cameraController.value!.description.lensDirection;

    final newLensDirection = currentLensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    final newDescription = cameras.firstWhere(
      (description) => description.lensDirection == newLensDirection,
      orElse: () => cameras.first,
    );

    await _initCamera(newDescription);
  }

  @override
  void onClose() {
    _imageService.dispose();
    super.onClose();
  }
}
