import 'package:flutter/material.dart';
import 'package:splach/widgets/highlight_mention.dart';

class MentionHighlightingController extends TextEditingController {
  MentionHighlightingController({String? text}) : super(text: text);

  @override
  set text(String newText) {
    value = TextEditingValue(
      text: newText,
      selection: selection,
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final text = value.text;
    final spans = highlightMention(text);

    return TextSpan(
      style: style,
      children: spans,
    );
  }
}
