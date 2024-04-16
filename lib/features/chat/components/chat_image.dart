import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splach/widgets/image_viewer.dart';

class ChatImage extends StatelessWidget {
  final String? image;
  final File? temporaryImage;
  final double maxHeight;
  final double maxWidth;

  const ChatImage({
    super.key,
    required this.image,
    this.temporaryImage,
    this.maxHeight = 180,
    this.maxWidth = 180,
  });

  @override
  Widget build(BuildContext context) {
    final showImage = image != null && image!.isNotEmpty;
    return GestureDetector(
      onTap: () => _showImageViewer(context),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        ),
        decoration: BoxDecoration(
          image: showImage
              ? DecorationImage(
                  image: NetworkImage(image!),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: FileImage(
                    temporaryImage!,
                  ),
                  fit: BoxFit.cover,
                ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showImageViewer(BuildContext context) {
    if (image != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ImageViewer(
            images: [image!],
          );
        },
      );
    }
  }
}
