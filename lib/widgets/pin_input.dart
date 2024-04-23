import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class PinInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmit;

  const PinInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return PinInputTextField(
      pinLength: 6,
      keyboardType: TextInputType.number,
      decoration: BoxLooseDecoration(
        textStyle: ThemeTypography.medium22.apply(
          color: ThemeColors.primary,
        ),
        strokeColorBuilder: PinListenColorBuilder(
          ThemeColors.grey4,
          ThemeColors.grey2,
        ),
        bgColorBuilder: PinListenColorBuilder(
          ThemeColors.grey1,
          ThemeColors.grey1,
        ),
      ),
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      onSubmit: onSubmit,
    );
  }
}
