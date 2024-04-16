import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';

class AvatarImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const AvatarImage({
    super.key,
    required this.image,
    this.height = 42,
    this.width = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColors.grey3,
        image: DecorationImage(
          image: NetworkImage(image),
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.tertiary.withOpacity(0.25),
            spreadRadius: -8,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
