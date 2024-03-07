import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/repositories/auth_repository.dart';
import 'package:splach/features/auth/views/login_view.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/utils/extensions.dart';

class LoginController extends GetxController {
  LoginController(this.navigator);

  final LoginNavigator navigator;

  final AuthRepository _authRepository = Get.find();
  final UserRepository _userRepository = Get.find();

  final phoneController = TextEditingController();
  final smsController = TextEditingController();

  final termsAndConditions = false.obs;
  final minutes = 5.obs;
  final seconds = 0.obs;
  final isCountdownFinished = false.obs;

  final loading = false.obs;

  final isLoginValid = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    phoneController.addListener(() {
      print('My phone number is changing...');
      isLoginValid.value = isPhoneValid && termsAndConditions.isTrue;
    });
    smsController.addListener(() {
      print('My phone number is changing...');
      isValid.value = isPhoneValid && termsAndConditions.isTrue && isSmsValid;
    });
    ever(
      termsAndConditions,
      (_) => isLoginValid.value = isPhoneValid && termsAndConditions.isTrue,
    );
  }

  Future<void> sendVerificationCode() async {
    try {
      final phoneNumber = '+55${phoneController.text}';

      await _authRepository.sendVerificationCode(phoneNumber);

      navigator.verification();
      startCountdown();
    } catch (e) {
      debugPrint('Verification code: $error');
      error(e.toString());
    }
  }

  Future<void> verifySmsCode() async {
    try {
      loading.value = true;
      await _authRepository.verifySmsCode(
        smsController.text,
      );

      if (_authRepository.authUser != null) {
        await _checkUserInDatabase(_authRepository.authUser!.uid);
      } else {
        loading.value = false;
        print('Auth SMS Code failed');
      }
    } catch (e) {
      error(e.toString());
    }
  }

  Future<void> _checkUserInDatabase(String id) async {
    try {
      final user = await _userRepository.get(id);

      if (user != null) {
        Get.put(user, permanent: true);
        navigator.home();
        loading.value = false;
        return;
      }

      loading.value = false;
      navigator.register();
    } catch (e) {
      debugPrint('Check User in database failed: $e');
    }
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();

        isCountdownFinished.value = true;
      } else {
        if (seconds.value == 0) {
          minutes.value--;
          seconds.value = 59;
        } else {
          seconds.value--;
        }
      }
    });
  }

  final isValid = false.obs;

  bool get isPhoneValid {
    final cleanPhone = phoneController.text.clean;

    return cleanPhone.length == 11;
  }

  bool get isSmsValid =>
      smsController.text.isNotEmpty && smsController.text.length == 6;

  String get inputError {
    if (isPhoneValid) {
      return 'Insira um telefone válido';
    } else if (termsAndConditions.isFalse) {
      return 'Para utilizar nossa plataforma, é preciso aceitar nossos Termos e Condições.';
    } else if (isSmsValid) {
      return 'SMS inválido';
    } else {
      return 'Algum campo necessita de atenção';
    }
  }
}
