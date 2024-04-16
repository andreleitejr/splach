import 'package:flutter/material.dart';
import 'package:splach/themes/theme_typography.dart';

import 'highlight_mention.dart';

class HighlightText extends StatelessWidget {
  final String text;

  const HighlightText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: ThemeTypography.regular14.apply(
          color: Colors.black,
        ),
        children: highlightMention(text),
      ),
    );
  }
}
