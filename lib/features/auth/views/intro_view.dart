import 'package:flutter/material.dart';
import 'package:splach/features/auth/components/intro_bottom_content.dart';
import 'package:splach/features/auth/components/language_dropdown_button.dart';
import 'package:splach/features/auth/controllers/auth_controller.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_images.dart';

class IntroView extends StatelessWidget {
  final AuthController controller;

  const IntroView({
    super.key,
    required this.controller,
  });

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
          const Positioned(
            top: 36,
            right: 20,
            child: LanguageDropdownButton(),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IntroBottomContent(),
          ),
        ],
      ),
    );
  }
}
