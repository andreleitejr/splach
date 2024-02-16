import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/input.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final bool required;
  final VoidCallback? onSubmit;
  // final Function(String) onChanged;
  final FocusNode? focus;

  PhoneInput({
    required this.controller,
    this.error,
    this.required = false,
    this.onSubmit,
    // required this.onChanged,
    this.focus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Input(
          controller: controller,
          keyboardType: TextInputType.phone,
          labelText: 'Phone',
        ),
        if (error != null && error!.isNotEmpty) ...[
          Text(
            error!,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
