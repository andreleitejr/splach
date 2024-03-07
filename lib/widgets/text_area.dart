import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class TextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onSubmit;
  final int maxLines;

  const TextArea({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.currentFocus,
    this.nextFocus,
    this.enabled = true,
    this.inputFormatters,
    this.onSubmit,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      enabled: enabled,
      controller: controller,
      focusNode: currentFocus,
      cursorColor: ThemeColors.primary,
      style: ThemeTypography.regular14.apply(
        color: enabled ? Colors.black : ThemeColors.grey4,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: hintText,
        hintStyle: ThemeTypography.regular14.apply(
          color: ThemeColors.grey4,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: ThemeColors.grey2,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: ThemeColors.grey3,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: ThemeColors.grey2,
          ),
        ),
      ),
      onEditingComplete: () {
        if (onSubmit != null) {
          onSubmit?.call();
          return;
        }
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      inputFormatters: inputFormatters,
      keyboardType: TextInputType.text,
    );
  }
}
