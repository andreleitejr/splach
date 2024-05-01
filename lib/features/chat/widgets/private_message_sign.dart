import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_icons.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/custom_icon.dart';

class PrivateMessageSign extends StatelessWidget {
  const PrivateMessageSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Text(
            'Private',
            style: ThemeTypography.medium10.copyWith(
              color: ThemeColors.tertiary,
            ),
          ),
          const SizedBox(width: 2),
           CustomIcon(
            ThemeIcons.lock,
            height: 11,
            color: ThemeColors.tertiary,
          ),
        ],
      ),
    );
  }
}
