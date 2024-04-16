import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:splach/services/image_service.dart';

class CameraGalleryController extends GetxController {
  File? image;

  final _imageService = CameraService();
  // AssetPathEntity? _path;
  final galleryImages = <File>[].obs;
  // final int _sizePerPage = 16;

  // final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
  //   imageOption: const FilterOption(
  //     sizeConstraint: SizeConstraint(ignoreSize: true),
  //   ),
  // );

  final loading = false.obs;

  final cameraController = Rx<CameraController?>(null);
  var cameras = <CameraDescription>[];

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

    // _imageService.dispose();
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
    final lensDirection = cameraController.value!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    await _initCamera(newDescription);
  }

  @override
  void onClose() {
    _imageService.dispose();
    super.onClose();
  }
}
