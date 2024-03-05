import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/controllers/auth_controller.dart';
import 'package:splach/features/auth/views/intro_view.dart';
import 'package:splach/features/auth/views/login_view.dart';
import 'package:splach/features/user/views/user_edit_view.dart';
import 'package:splach/themes/theme_colors.dart';

abstract class AuthNavigator {
  void intro();

  void register();

   void home();
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> implements AuthNavigator {
  late AuthController controller;

  @override
  void initState() {
    controller = Get.put(AuthController(this));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.primary,
      ),
    );
  }

  @override
  void intro() {
    Get.to(() => IntroView(controller: controller));
  }

  @override
  void home() {
    Get.offAllNamed('/home');
  }

  @override
  void register() {
    Get.to(
      () => UserEditView(),
    );
  }
}
