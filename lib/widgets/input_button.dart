import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splach/widgets/input.dart';

class InputButton extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final String? error;
  final VoidCallback onTap;
  final bool required;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;

  const InputButton({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.error,
    required this.onTap,
    this.required = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Input(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
