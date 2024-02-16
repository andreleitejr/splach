import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

import 'pin_input.dart';

class CodeWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final String phoneNumber;
  // final Function(String) onChanged;
  final FocusNode focusNode;

  CodeWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.phoneNumber,
    // required this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verificação',
          style: ThemeTypography.regular14
              .apply(color: const Color(0xFF666666), fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enviamos um código para o número:',
          style: ThemeTypography.medium14,
        ),
        const SizedBox(height: 4),
        Text(
          phoneNumber,
          style: ThemeTypography.medium14.apply(
            color: ThemeColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        PinInput(
          controller: controller,
          focusNode: focusNode,
          // onChanged: onChanged,
          onSubmit: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
