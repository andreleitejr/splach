import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_images.dart';
import 'package:splach/themes/theme_typography.dart';

class AvatarImageInput extends StatelessWidget {
  final File? image;
  final VoidCallback onPressed;

  const AvatarImageInput({
    super.key,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final decodedImage = image != null
        ? DecorationImage(image: FileImage(image!))
        : const DecorationImage(
            image: AssetImage(ThemeImages.selectImage),
            fit: BoxFit.cover,
          );
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 128,
            width: 128,
            decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Colors.white,
              ),
              color: const Color(0xFFADB6DD),
              borderRadius: BorderRadius.circular(100),
              image: decodedImage,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.tertiary.withOpacity(0.25),
                  spreadRadius: -8,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            image != null ? 'You look awesome!' : 'Select your best photo',
            style: ThemeTypography.medium14.apply(
              color: ThemeColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
