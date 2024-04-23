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

  final isLoginValid = false.obs;
  final isValid = false.obs;

  final error = ''.obs;

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();

    phoneController.addListener(() {
      isLoginValid.value = isPhoneValid && termsAndConditions.isTrue;
    });
    smsController.addListener(() {
      isValid.value = isPhoneValid && termsAndConditions.isTrue && isSmsValid;
    });
    ever(
      termsAndConditions,
      (_) => isLoginValid.value = isPhoneValid && termsAndConditions.isTrue,
    );
  }

  bool get isPhoneValid {
    final cleanPhone = phoneController.text.clean;

    return cleanPhone.length == 11;
  }

  bool get isSmsValid =>
      smsController.text.isNotEmpty && smsController.text.length == 6;

  Future<void> sendVerificationCode() async {
    try {
      final phoneNumber = '+55${phoneController.text}';

      await _authRepository.sendVerificationCode(
        phoneNumber,
      );

      navigator.verification();
      startCountdown();
    } catch (e) {
      debugPrint('Sending verification code: $error');
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
        await _checkUserInDatabase(
          _authRepository.authUser!.uid,
        );
      } else {
        loading.value = false;
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

  String get inputError {
    if (isPhoneValid) {
      return 'Insert a valid phone number';
    } else if (termsAndConditions.isFalse) {
      return 'You must agree with out Terms and Conditions to use our platform.';
    } else if (isSmsValid) {
      return 'You entered an invalid code. Try again.';
    } else {
      return 'Some field needs attention.';
    }
  }

  String get countdownText => 'Send code again '
      '(${minutes.value.toString().padLeft(2, '0')}'
      ':${seconds.value.toString().padLeft(2, '0')})';
}
