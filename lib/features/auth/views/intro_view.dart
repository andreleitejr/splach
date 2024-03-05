import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/auth/components/language_selection.dart';
import 'package:splach/features/auth/controllers/auth_controller.dart';
import 'package:splach/features/auth/views/login_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_images.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/flat_button.dart';
import 'package:splach/widgets/primary_button.dart';

class IntroView extends StatelessWidget {
  final AuthController controller;

  const IntroView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: ThemeColors.primary,
              image: DecorationImage(
                image: AssetImage(
                  ThemeImages.introBackground,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: LanguageDropdownButton(),
          ),
          // Parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'splach',
                    style: ThemeTypography.extraBold22.apply(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Here goes the app slogan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 36),
                  FlatButton(
                    actionText: 'Vamos lá',
                    onPressed: () => Get.to(
                      () => const LoginView(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageDropdownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.to(() => LanguageSelection());
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: const Row(
        children: [
          Text('Selecionar Idioma'),
          SizedBox(width: 4),
          Icon(
            Icons.language,
            size: 16,
          ),
        ],
      ),
    );
  }
}
