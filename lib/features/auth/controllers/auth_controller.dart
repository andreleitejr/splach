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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        navigator.intro();
      });
    }
  }

  Future<void> _checkUserInDatabase(String id) async {
    try {
      final user = await _userRepository.get(id);

      if (user != null) {
        Get.put(user, permanent: true);
        debugPrint('Successfully logged with id ${user.id!}');
        navigator.home();
        return;
      }

      navigator.register();
    } catch (e) {
      debugPrint('Check User in database failed: $e');
    }
  }
}
