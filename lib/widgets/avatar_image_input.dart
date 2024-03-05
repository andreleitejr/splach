import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splach/widgets/input.dart';

class AvatarImageInput extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;

  const AvatarImageInput({
    super.key,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image.isNotEmpty
            ? MemoryImage(
                base64Decode(image),
              )
            : null,
      ),
    );
  }
}
