import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final genderController = TextEditingController();
  final Rx<DateTime?> birthday = Rx<DateTime?>(null);

  // final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  final isFormValid = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    countryController.text = 'Brasil';

    // nameController.addListener(() => validateForm());
    // emailController.addListener(() => validateForm());
    // nicknameController.addListener(() => validateForm());
    // genderController.addListener(() => validateForm());
    // stateController.addListener(() => validateForm());
  }

  void validateForm() {
    final List<String> requiredFields = [];

    if (!GetUtils.isEmail(emailController.text)) {
      requiredFields.add('Email');
    }

    if (nameController.text.isEmpty) {
      requiredFields.add('Nome');
    }

    if (nicknameController.text.isEmpty) {
      requiredFields.add('Nickname');
    }

    if (genderController.text.isEmpty) {
      requiredFields.add('Gênero');
    }

    if (birthday.value == null) {
      requiredFields.add('Data de nascimento');
    }

    if (stateController.text.isEmpty) {
      requiredFields.add('Estado');
    }

    if (requiredFields.isEmpty) {
      errorMessage.value = '';
    } else {
      errorMessage.value =
          'Os seguintes campos são obrigatórios: ${requiredFields.join(', ')}';
    }

    isFormValid.value = requiredFields.isEmpty;
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
      name: nameController.text,
      nickname: nicknameController.text,
      phone: _authRepository.authUser!.phoneNumber!,
      gender: genderController.text,
      birthday: birthday.value!,
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
