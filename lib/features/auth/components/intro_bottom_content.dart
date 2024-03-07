import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/auth/views/login_view.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/flat_button.dart';

class IntroBottomContent extends StatelessWidget {
  const IntroBottomContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'splach',
            style: ThemeTypography.extraBold22.apply(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Here goes the app slogan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          FlatButton(
            actionText: 'Let\'s go',
            onPressed: () => Get.to(
              () => const LoginView(),
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
