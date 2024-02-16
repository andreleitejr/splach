import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/repositories/auth_repository.dart';
import 'package:splach/features/auth/views/auth_view.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/utils/extensions.dart';

class AuthController extends GetxController {
  AuthController(this.navigator);

  final AuthNavigator navigator;
  final _authRepository = Get.put(AuthRepository());
  final _userRepository = Get.put(UserRepository(), permanent: true);

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  final termsAndConditions = false.obs;
  final minutes = 5.obs;
  final seconds = 0.obs;
  final isCountdownFinished = false.obs;

  // final authStatus = AuthStatus.unauthenticated.obs;
  final error = ''.obs;
  final loading = false.obs;

  final showErrors = RxBool(false);

  @override
  Future<void> onInit() async {
    super.onInit();

    loading(true);

    _authRepository.getCurrentUser();

    await checkCurrentUser();

    loading(false);
  }

  Future<void> checkCurrentUser() async {
    if (_authRepository.authUser != null) {
      await _checkUserInDatabase(_authRepository.authUser!.uid);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigator.login();
      });
    }
  }

  Future<void> _checkUserInDatabase(String id) async {
    try {
      print(' Jesus ${id}');
      final user = await _userRepository.get(id);

      if (user != null) {
        Get.put(user, permanent: true);
        navigator.home();
        return;
      }

      navigator.register();
    } catch (e) {
      debugPrint('Check User in database failed: $e');
    }
  }

  Future<void> sendVerificationCode() async {
    try {
      print('HAUSDHDSUSHAUASDHUDHD');
      await _authRepository.sendVerificationCode('+55${phoneController.text}');
      navigator.verification();
      startCountdown();
    } catch (e) {
      debugPrint('Verification code: $error');
      error(e.toString());
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

  Future<void> verifySmsCode() async {
    try {
      print('HAUSDHDSUSHAUASDHUDHD 2');
      await _authRepository.verifySmsCode(
        smsController.text,
      );

      if (_authRepository.authUser != null) {
        await _checkUserInDatabase(_authRepository.authUser!.uid);
      } else {
        print('Auth SMS Code failed');
      }
    } catch (e) {
      print('HAUSDHDSUSHAUASDHUDHD ERROR  ${e.toString()}');
      error(e.toString());
    }
  }

  RxBool get isValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue && isSmsValid.isTrue)
          .obs;

  RxBool get isLoginValid =>
      (isPhoneValid.isTrue && termsAndConditions.isTrue).obs;

  RxBool get isPhoneValid {
    final cleanPhone = phoneController.text.clean;

    return (cleanPhone.length == 11).obs;
  }

  RxBool get isSmsValid =>
      (smsController.text.isNotEmpty && smsController.text.length == 6).obs;

  String get inputError {
    if (isPhoneValid.isFalse) {
      return 'Insira um telefone válido';
    } else if (termsAndConditions.isFalse) {
      return 'Para utilizar nossa plataforma, é preciso aceitar nossos Termos e Condições.';
    } else if (isSmsValid.isFalse) {
      return 'SMS inválido';
    } else {
      return 'Algum campo necessita de atenção';
    }
  }
}
