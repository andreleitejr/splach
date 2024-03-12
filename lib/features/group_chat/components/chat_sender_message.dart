import 'package:flutter/material.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';

import 'chat_highlight_mention.dart';

class ChatSenderMessage extends StatelessWidget {
  final Message message;
  final VoidCallback? onDoubleTap;
  final Function(DragEndDetails)? onHorizontalDragEnd;

  const ChatSenderMessage({
    super.key,
    required this.message,
    this.onDoubleTap,
    this.onHorizontalDragEnd,
  });

  final double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onHorizontalDragEnd: onHorizontalDragEnd,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.sender != null) ...[
            AvatarImage(image: message.sender!.image),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color:  Colors.white,
              border: Border.all(
                color: ThemeColors.grey2,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(_borderRadius),
                bottomLeft: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.sender != null) ...[
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
                        color: Colors.black,
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
                    color: ThemeColors.grey4,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
