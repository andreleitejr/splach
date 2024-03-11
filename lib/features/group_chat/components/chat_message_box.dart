import 'package:flutter/material.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';

class ChatMessageBox extends StatelessWidget {
  final Message message;

  const ChatMessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isFromUser && message.sender != null) ...[
          AvatarImage(image: message.sender!.image),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: message.isFromUser ? ThemeColors.primary : Colors.white,
            border: Border.all(
              color: ThemeColors.grey2,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(message.isFromUser ? 12 : 0),
              topRight: Radius.circular(message.isFromUser ? 0 : 12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isFromUser && message.sender != null) ...[
                Text(
                  '@${message.sender!.nickname}',
                  style: ThemeTypography.semiBold12.apply(
                    color: ThemeColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 75,
                  maxWidth: MediaQuery.of(context).size.width * 0.65 - 32,
                ),
                child: RichText(
                  text: TextSpan(
                    style: ThemeTypography.regular14.apply(
                      color: message.isFromUser ? Colors.white : Colors.black,
                    ),
                    children: highlightMentions(
                      message.content,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${message.createdAt.toTimeString()} ago',
                style: ThemeTypography.regular9.apply(
                  color: message.isFromUser
                      ? ThemeColors.light
                      : ThemeColors.grey4,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TextSpan> highlightMentions(String text) {
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
            color: message.isFromUser
                ? ThemeColors.fuchsia60
                : ThemeColors.primary,
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
}
