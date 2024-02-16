import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String value;
  final String hint;

  const InputButton({
    super.key,
    required this.onPressed,
    required this.value,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        width: double.infinity,
        color: Colors.grey,
        child: Text(value.isEmpty ? hint : value),
      ),
    );
  }
}
