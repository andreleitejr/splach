import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class PrivateMessageSign extends StatelessWidget {
  const PrivateMessageSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeColors.grey2,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            'Private',
            style: ThemeTypography.semiBold12.copyWith(
              color: ThemeColors.grey4,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.lock_outline,
            size: 12,
          ),
        ],
      ),
    );
  }
}
