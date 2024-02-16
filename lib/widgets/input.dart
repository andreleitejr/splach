import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const Input({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
    );
  }
}
