import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class UserProfileHeader extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const UserProfileHeader({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: MemoryImage(
                  base64Decode(image),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ThemeTypography.semiBold16,
                  ),
                  const SizedBox(height: 8),
                  _buildDescriptionText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    final showAllText = description.length > 50;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: description.length <= 50
                ? description
                : description.substring(0, 50) + (showAllText ? "..." : ""),
            style: ThemeTypography.regular14.apply(
              color: ThemeColors.grey4,
            ),
          ),
          if (showAllText) ...[
            TextSpan(
              text: ' Ver tudo',
              style: ThemeTypography.regular14.apply(
                color: ThemeColors.primary,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
        ],
      ),
    );
  }
}
