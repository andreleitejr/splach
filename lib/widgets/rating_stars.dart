import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_images.dart';

// ignore: must_be_immutable
class RatingStars extends StatelessWidget {
  double score;
  final Function(double) onPressed;

  RatingStars({super.key, required this.score, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          5,
          (index) => GestureDetector(
            onTap: () {
              onPressed(index + 1);
            },
            child: SvgPicture.asset(
              ThemeImages.ratingStar,
              height: 40,
              colorFilter: ColorFilter.mode(
                index < score ? ThemeColors.yellow : ThemeColors.grey2,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
