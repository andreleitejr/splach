import 'package:flutter/material.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/widgets/image_viewer.dart';

class GalleryItem extends StatelessWidget {
  final Gallery galleryImage;

  const GalleryItem({
    super.key,
    required this.galleryImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageViewer(context, galleryImage),
      child: Image.network(
        galleryImage.image,
        fit: BoxFit.cover,
      ),
    );
  }

  void _showImageViewer(BuildContext context, Gallery image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewer(
          images: [image.image],
          description: image.description,
        );
      },
    );
  }
}
