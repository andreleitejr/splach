import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splach/features/address/controllers/address_edit_controller.dart';
import 'package:splach/features/chat/models/group_chat.dart';
import 'package:splach/features/chat/repositories/chat_repository.dart';
import 'package:splach/features/chat/repositories/chat_storage_repository.dart';
import 'package:splach/features/services/location_service.dart';
import 'package:splach/features/chat/models/chat_category.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/services/image_service.dart';

class GroupChatEditController extends GetxController {
  final ChatRepository _repository = Get.find();
  final LocationService _locationService = Get.find();
  final addressController = Get.put(AddressEditController());
  final _chatStorageRepository = Get.put(ChatStorageRepository());
  final _imageService = CameraService();

  final groupChat = Rx<GroupChat?>(null);
  final currentLocation = Rx<Position?>(null);

  final image = Rx<File?>(null);
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // final category = ''.obs;

  final categoryController = TextEditingController();

  @override
  Future<void> onInit() async {
    currentLocation.value = await _locationService.getCurrentLocation();
    super.onInit();
  }

  /// TODO: Get Current Address Based On Current Coordinates

  Future<void> pickImage(ImageSource source) async {
    final file = await _imageService.takePhoto();

    if (file != null) {
      image.value = file;
    } else {
      // errorMessage.value =
      // 'Houve um erro ao carregar a imagem. Tente novamente.';
    }
  }

  Future<SaveResult?> save() async {
    final imageUrl = await _uploadImageIfRequired();

    final newGroupChat = GroupChat(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      participants: [],
      participantsLimit: 35,
      messages: [],
      images: [imageUrl!],
      location: GeoPoint(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      ),
      address: addressController.address,
      title: titleController.text,
      description: descriptionController.text,
      groupType: GroupType.public,
      category: categories
          .firstWhere((c) => c.name == categoryController.text)
          .category,
      lastActivity: DateTime.now(),
    );

    return await _repository.save(newGroupChat);
  }

  Future<String?> _uploadImageIfRequired() async {
    if (image.value == null) return null;
    return await _chatStorageRepository.upload(image.value!);
  }
}
