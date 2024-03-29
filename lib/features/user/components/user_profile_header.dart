import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/image_viewer.dart';

class UserProfileHeader extends StatelessWidget {
  final User user;

  const UserProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageViewer(
                        images: [user.image],
                      );
                    },
                  );
                },
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: MemoryImage(
                        base64Decode(user.image),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (user.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star),
                    Text(user.rating!.toString()),
                  ],
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nickname.toNickname(),
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
    final description = user.description;
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
