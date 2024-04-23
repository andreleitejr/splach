import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_country_image.dart';
import 'package:splach/themes/theme_typography.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final bool required;
  final VoidCallback? onSubmit;
  final FocusNode? focus;

  const PhoneInput({
    super.key,
    required this.controller,
    this.error,
    this.required = false,
    this.onSubmit,
    this.focus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          focusNode: focus,
          onEditingComplete: onSubmit,
          style: ThemeTypography.medium14.apply(
            color: ThemeColors.primary,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: '(11) 99000-0000',
            hintStyle: ThemeTypography.regular14.apply(
              color: ThemeColors.grey3,
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  ThemeCountryImage.brazil,
                  width: 24,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black26,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Container(
                  height: 20,
                  color: ThemeColors.grey2,
                  width: 1,
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            fillColor: ThemeColors.grey1,
            filled: true,
          ),
          // onChanged: onChanged,
        ),
        if (error != null && error!.isNotEmpty) ...[
          Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
