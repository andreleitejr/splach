import 'package:flutter/material.dart';
import 'package:splach/themes/theme_typography.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final VoidCallback onTap;
  final Color? textColor;

  const CustomListTile({
    super.key,
    required this.title,
    this.leading,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: ThemeTypography.medium14.apply(color: textColor),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
