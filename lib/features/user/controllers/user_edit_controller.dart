import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/address/models/address.dart';
import 'package:splach/features/auth/repositories/auth_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class UserEditController extends GetxController {
  final _repository = Get.put(UserRepository());
  final AuthRepository _authRepository = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController complementController = TextEditingController();

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

  Future<SaveResult?> save() async {
    print(
        'HUDHDSUHUDHUDSAHASDUAHDSU SALSICHA EMPANADA ${_authRepository.authUser!.uid}');
    final newUser = User(
      id: _authRepository.authUser!.uid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      email: emailController.text,
      image: imageController.text,
      document: documentController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      nickname: nicknameController.text,
      phone: phoneController.text,
      gender: genderController.text,
      birthday: DateTime.now(),
      address: Address(
        postalCode: postalCodeController.text,
        street: streetController.text,
        number: numberController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        complement: complementController.text,
      ),
    );

    return await _repository.save(newUser, docId: newUser.id);
    // _groupChat.value = newGroupChat;
  }
}
