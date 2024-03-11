import 'package:flutter/material.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';

class ChatSystemMessage extends StatelessWidget {
  final Message message;

  const ChatSystemMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 3,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ThemeColors.grey2,
            borderRadius: BorderRadius.circular(48),
          ),
          child: Text(
            message.content,
            style: ThemeTypography.regular12.apply(
              color: ThemeColors.grey4,
            ),
          ),
        ),
      ],
    );
  }
}
