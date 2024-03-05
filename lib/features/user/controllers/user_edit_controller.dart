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

  // final documentController = TextEditingController();
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  // final lastNameController = TextEditingController();
  final nicknameController = TextEditingController();

  // final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();

  // final addressController = TextEditingController();

  // final postalCodeController = TextEditingController();
  // final streetController = TextEditingController();
  // final numberController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  // final complementController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Preencha os controladores com os dados atuais do usuário
    // emailController.text = user.email;
    // imageController.text = user.image;
    // documentController.text = user.document;
    // firstNameController.text = user.firstName;
    // lastNameController.text = user.lastName;
    // nicknameController.text = user.nickname;
    // phoneController.text = user.phone;
    // genderController.text = user.gender;
    // birthdayController.text = user.birthday.toLocal().toString();
    // addressController.text = user.address.toString(); // Ajuste conforme a lógica da classe Address
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
      // document: documentController.text,
      firstName: firstNameController.text,
      // lastName: lastNameController.text,
      nickname: nicknameController.text,
      phone: _authRepository.authUser!.phoneNumber!,
      gender: genderController.text,
      birthday: DateTime.now(),

      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
    );

    return await _repository.save(newUser, docId: newUser.id);
  }
}
