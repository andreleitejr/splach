import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              index < score
                  ? ThemeImages.ratingStar
                  : ThemeImages.ratingStarUnselected,
              // width: (MediaQuery.of(context).size.width - 32) * 0.1,
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
