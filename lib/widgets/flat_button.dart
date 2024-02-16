import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class FlatButton extends StatelessWidget {
  final String actionText;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget icon;
  final bool isValid;

  const FlatButton({
    super.key,
    required this.actionText,
    required this.onPressed,
    this.icon = const SizedBox(),
    this.backgroundColor = ThemeColors.primary,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: isValid ? backgroundColor : ThemeColors.grey2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 4),
              Text(
                actionText,
                style: ThemeTypography.semiBold16.apply(color: Colors.white),
              ),
            ],
          )),
    );
  }
}
