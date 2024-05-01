import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

import 'highlight_mention.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final bool isReply;

  const HighlightText(
    this.text, {
    super.key,
    this.maxLines,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
      text: TextSpan(
        style: ThemeTypography.regular14.apply(
          color: isReply ? ThemeColors.grey4 : Colors.black,
        ),
        children: highlightMention(text),
      ),
    );
  }
}
