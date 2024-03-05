import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class LanguageSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Selecione um idioma',
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
      title: Text(language),
      onTap: () {
        Get.back();
      },
    );
  }
}
