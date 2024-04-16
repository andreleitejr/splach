import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;

  const TopNavigationBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.showLeading = true,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final showLeadingButton = showLeading || onLeadingPressed != null;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showLeadingButton ? _leadingButton() : null,
      title: Text(
        title,
        style: ThemeTypography.medium16.apply(
          color: ThemeColors.grey5,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  Widget _leadingButton() {
    return IconButton(
      onPressed: () {
        if (onLeadingPressed != null) {
          onLeadingPressed!();
        } else {
          Get.back();
        }
      },
      icon: const Icon(
        Icons.arrow_back,
        color: ThemeColors.grey5,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
