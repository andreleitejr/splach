import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(
        title: 'Select your language',
      ),
      body: _buildLanguageOptions(),
    );
  }

  Widget _buildLanguageOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLanguageOption('Português (BR)'),
        _buildLanguageOption('English (US)'),
        _buildLanguageOption('Español'),
      ],
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(
        language,
        style: ThemeTypography.medium14,
      ),
      onTap: () {
        Get.back();
      },
    );
  }
}
