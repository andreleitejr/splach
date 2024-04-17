import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/repositories/auth_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/features/user/repositories/user_storage_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class UserEditController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  final _repository = Get.put(UserRepository());
  final _storageRepository = Get.put(UserStorageRepository());

  final image = Rx<File?>(null);
  String imageUrl = '';
  final name = TextEditingController();
  final description = TextEditingController();
  final email = TextEditingController();
  final nickname = TextEditingController();
  final gender = TextEditingController();
  final birthday = Rx<DateTime?>(null);
  final state = TextEditingController();
  final country = TextEditingController();

  final isPrimaryDataValid = false.obs;
  final isSecondaryDataValid = false.obs;

  RxBool get isValid =>
      (isPrimaryDataValid.isTrue && isSecondaryDataValid.isTrue).obs;

  final errorMessage = ''.obs;
  final showErrorMessage = false.obs;

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();

    country.text = 'Brasil';

    email.addListener(() => validatePrimaryForm());
    gender.addListener(() => validatePrimaryForm());
    state.addListener(() => validatePrimaryForm());
    ever(birthday, (_) => validatePrimaryForm());

    ever(image, (_) => validateSecondaryForm());
    nickname.addListener(() => validateSecondaryForm());
    name.addListener(() => validateSecondaryForm());
    description.addListener(() => validateSecondaryForm());
  }

  void validatePrimaryForm() {
    final requiredFields = _getPrimaryDataErrorMessage();
    isPrimaryDataValid.value = requiredFields.isEmpty;
  }

  void validateSecondaryForm() {
    final requiredFields = _getSecondaryDataErrorMessage();
    isSecondaryDataValid.value = requiredFields.isEmpty;
  }

  List<String> _getPrimaryDataErrorMessage() {
    final List<String> requiredFields = [];

    if (!GetUtils.isEmail(email.text)) {
      requiredFields.add('Email');
    }

    if (gender.text.isEmpty) {
      requiredFields.add('Gender');
    }

    if (birthday.value == null) {
      requiredFields.add('Birthday');
    }

    if (state.text.isEmpty) {
      requiredFields.add('State');
    }

    if (requiredFields.isEmpty) {
      errorMessage.value = '';
    } else {
      errorMessage.value = 'Mandatory fields: ${requiredFields.join(', ')}';
    }
    return requiredFields;
  }

  List<String> _getSecondaryDataErrorMessage() {
    final List<String> requiredFields = [];
    if (image.value == null) {
      requiredFields.add('Image');
    }

    if (nickname.text.isEmpty) {
      requiredFields.add('Nickname');
    }

    if (name.text.isEmpty) {
      requiredFields.add('Name');
    }

    if (description.text.isEmpty) {
      requiredFields.add('Description');
    }

    if (requiredFields.isEmpty) {
      errorMessage.value = '';
    } else {
      errorMessage.value = 'Mandatory fields: ${requiredFields.join(', ')}';
    }
    return requiredFields;
  }

  Future<SaveResult?> save() async {
    loading.value = true;

    final imageUrl = await _uploadImageIfRequired();

    /// UPLOAD DE FOTO AQUI
    final newUser = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      phone: _authRepository.authUser!.phoneNumber!,
      email: email.text,
      image: imageUrl,
      nickname: nickname.text,
      name: name.text,
      description: description.text,
      gender: gender.text,
      birthday: birthday.value!,
      state: state.text,
      country: country.text,
    );

    final result = await _repository.save(newUser, docId: newUser.id);

    if (result == SaveResult.success) {
      Get.put(newUser, permanent: true);
    }

    loading.value = false;
    return result;
  }

  Future<String?> _uploadImageIfRequired() async {
    if (image.value == null) return null;
    return await _storageRepository.upload(image.value!);
  }
}
