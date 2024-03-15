import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/controllers/camera_gallery_controller.dart';

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
                        onTap: (){
                          print('######################################################');
                          Get.back(result: galleryImage);
                        },
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
