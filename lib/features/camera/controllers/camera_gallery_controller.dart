import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:splach/services/image_service.dart';

class CameraGalleryController extends GetxController {
  String? image;

  final _imageService = CameraService();
  AssetPathEntity? _path;
  final galleryImages = <String>[].obs;
  final int _sizePerPage = 16;

  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );

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
    final base64Image = await _imageService.takePhoto();

    if (base64Image != null) {
      image = base64Image;
    }

    // _imageService.dispose();
  }

  Future<void> pickImageFromGallery() async {
    final base64Image = await _imageService.pickImageFromGallery();

    if (base64Image != null) {
      image = base64Image;
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

  Future<void> _initCamera(CameraDescription description) async {
    cameraController.value =
        CameraController(description, ResolutionPreset.medium);

    try {
      await cameraController.value!.initialize();
    } catch (e) {
      debugPrint('Initializing Camera after toggle error: $e');
    }
  }

  Future<void> _requestAssets() async {
    final PermissionStatus status = await Permission.photos.request();

    if (status.isDenied) {
      print('Permission is not accessible. $status');
      return;
    }

    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      filterOption: _filterOptionGroup,
    );

    if (paths.isEmpty) {
      return;
    }

    _path = paths.first;
    // _totalEntitiesCount = await _path!.assetCountAsync;
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );

    final files = <File>[];
    for (final entity in entities) {
      final file = await entity.file;
      files.add(file!);
    }

    galleryImages.value = await _imageService.filesToBase64(files);
  }

  @override
  void onClose() {
    _imageService.dispose();
    super.onClose();
  }
}