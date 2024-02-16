import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/services/location_service.dart';
import 'package:splach/repositories/chat_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class GroupChatEditController extends GetxController {
  final GroupChatRepository _repository = Get.find();
  final LocationService _locationService = Get.find();

  final groupChat = Rx<GroupChat?>(null);
  final currentLocation = Rx<Position?>(null);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  Future<void> onInit() async {
    currentLocation.value = await _locationService.getCurrentLocation();
    super.onInit();
  }

  /// TODO: Get Current Address Based On Current Coordinates

  Future<SaveResult?> save() async {
    final newGroupChat = GroupChat(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      participants: [],
      participantsLimit: 10,
      messages: [],
      images: [],
      location: GeoPoint(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      ),
      title: titleController.text,
      description: descriptionController.text,
      groupType: GroupType.public,
    );

    return await _repository.save(newGroupChat);
    // _groupChat.value = newGroupChat;
  }

}
