import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/camera/controllers/camera_gallery_controller.dart';
import 'package:splach/features/chat/components/chat_image_input.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';

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
            Obx(
              () {
                if (cameraController.cameraController.value == null) {
                  return Container();
                }
                return Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CameraPreview(
                      cameraController.cameraController.value!,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (cameraController.galleryImages.isNotEmpty) {
                return SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: cameraController.galleryImages.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final galleryImage =
                          cameraController.galleryImages[index];
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
                                cameraController.galleryImages[index],
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
              if (cameraController.galleryImages.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () async {
                            await cameraController.pickImageFromGallery();
                            if (cameraController.image != null) {
                              // Get.back(result: cameraController.image!);

                              // controller.image.value =
                              //     cameraController.image!;

                              Get.back(result: cameraController.image!);
                            }
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image: FileImage(
                                  cameraController.galleryImages.first,
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
                          await cameraController.takePhoto();
                          if (cameraController.image != null) {
                            // Get.back(result: cameraController.image!);

                            // controller.image.value =
                            //     cameraController.image!;

                            Get.back(result: cameraController.image!);
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
                            await cameraController.toggleCameraLens();
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
