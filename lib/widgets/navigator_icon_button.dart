import 'package:flutter/material.dart';
import 'package:splach/widgets/custom_icon.dart';

class NavigatorIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final double? iconHeight;

  const NavigatorIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.padding,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 0,
          ),
      child: GestureDetector(
        onTap: onPressed,
        child: CustomIcon(
          icon,
          height: iconHeight ?? 24,
        ),
      ),
    );
  }
}
