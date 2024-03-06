import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splach/features/address/models/address.dart';
import 'package:splach/features/auth/repositories/auth_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/services/image_service.dart';

class UserEditController extends GetxController {
  final _repository = Get.put(UserRepository());
  final AuthRepository _authRepository = Get.find();

  final ImageService _imageService = ImageService();

  final RxString imageController = RxString('');
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final genderController = TextEditingController();
  final Rx<DateTime?> birthday = Rx<DateTime?>(null);
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    countryController.text = 'Brasil';
  }

  Future<void> pickImage(ImageSource source) async {
    final String? base64Image = await _imageService.takePhoto(source);

    if (base64Image != null) {
      imageController.value = base64Image;
    } else {
      // ImageError
    }
  }

  Future<SaveResult?> save() async {
    final newUser = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      email: emailController.text,
      image: imageController.value,
      firstName: firstNameController.text,
      nickname: nicknameController.text,
      phone: _authRepository.authUser!.phoneNumber!,
      gender: genderController.text,
      birthday: DateTime.now(),
      state: stateController.text,
      country: countryController.text,
    );

    final result = await _repository.save(newUser, docId: newUser.id);
    if (result == SaveResult.success) {
      Get.put(newUser, permanent: true);
    }
    return result;
  }
}
