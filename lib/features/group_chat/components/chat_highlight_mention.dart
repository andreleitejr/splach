import 'package:flutter/material.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

List<TextSpan> highlightMentions(
  String text, {
  bool isFromUser = false,
}) {
  List<TextSpan> spans = [];
  RegExp mentionRegex = RegExp(r'@(\S+)', caseSensitive: false);
  List<RegExpMatch> matches = mentionRegex.allMatches(text).toList();

  int lastMatchEnd = 0;
  for (RegExpMatch match in matches) {
    if (match.start > lastMatchEnd) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ),
      );
    }

    spans.add(
      TextSpan(
        text: match.group(0),
        style: ThemeTypography.medium14.apply(
          color: isFromUser ? ThemeColors.fuchsia60 : ThemeColors.primary,
        ),
      ),
    );

    lastMatchEnd = match.end;
  }

  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(text: text.substring(lastMatchEnd)));
  }

  return spans;
}
