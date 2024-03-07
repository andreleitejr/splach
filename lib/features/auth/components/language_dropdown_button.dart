import 'package:flutter/material.dart';
import 'package:splach/themes/theme_typography.dart';

class LanguageDropdownButton extends StatelessWidget {
  const LanguageDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        /// TODO: Uncomment when internalization is done
        // Get.to(() => LanguageSelection());
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: const Row(
        children: [
          Text(
            'Português (BR)',
            style: ThemeTypography.regular14,
          ),
          SizedBox(width: 4),
          Icon(
            Icons.language,
            size: 14,
          ),
        ],
      ),
    );
  }
}
