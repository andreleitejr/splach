import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;

  const Input({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType,
    this.currentFocus,
    this.nextFocus,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.text,
    );
  }
}
