import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splach/widgets/image_viewer.dart';

class ChatImage extends StatelessWidget {
  final String image;
  final double maxHeight;
  final double maxWidth;

  const ChatImage({
    super.key,
    required this.image,
    this.maxHeight = 180,
    this.maxWidth = 180,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ImageViewer(
              images: [image],
            );
          },
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
