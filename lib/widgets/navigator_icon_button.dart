import 'package:flutter/material.dart';

class NavigatorIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const NavigatorIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
