import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchButton({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (newValue) {
        onChanged?.call(newValue);
      },
    );
  }
}
