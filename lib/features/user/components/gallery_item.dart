import 'package:flutter/material.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/image_viewer.dart';

class GalleryItem extends StatelessWidget {
  final Gallery galleryImage;
  const GalleryItem({super.key, required this.galleryImage});

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => _showImageViewer(context, galleryImage.image),
      child:  Image.network(
        galleryImage.image,
        fit: BoxFit.cover,
      ),
    );
  }
  void _showImageViewer(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewer(
          images: [image],
        );
      },
    );
  }
}
