import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RatingStars extends StatelessWidget {
  double score;
  final Function(double) onPressed;

  RatingStars({super.key, required this.score, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        5,
        (index) => IconButton(
          onPressed: () {
            onPressed(index + 1);
          },
          icon: Icon(
            index < score ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 36,
          ),
        ),
      ),
    );
  }
}
