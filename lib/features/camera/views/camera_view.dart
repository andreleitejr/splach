import 'dart:convert';
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

class CameraGalleryView extends StatefulWidget {
  // final Function(String) onImageSelected;

  const CameraGalleryView({
    super.key,
    // required this.controller,
    // required this.onImageSelected,
  });

  @override
  State<CameraGalleryView> createState() => _CameraGalleryViewState();
}

class _CameraGalleryViewState extends State<CameraGalleryView> {
  final controller = Get.put(CameraGalleryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () {
                if (controller.cameraController.value == null) {
                  return Container();
                }
                return Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CameraPreview(
                      controller.cameraController.value!,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.galleryImages.isNotEmpty) {
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
                        onTap: () => Get.back(result: galleryImage),
                        child: Container(
                          height: 80,
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: MemoryImage(
                                base64Decode(
                                  controller.galleryImages[index],
                                ),
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
              return Container();
            }),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.galleryImages.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
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
                                image: MemoryImage(
                                  base64Decode(
                                    controller.galleryImages.first,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
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
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            await controller.toggleCameraLens();
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.change_circle_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
