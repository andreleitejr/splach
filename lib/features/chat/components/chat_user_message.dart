import 'package:flutter/material.dart';
import 'package:splach/features/chat/components/chat_image.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/chat/widgets/private_message_sign.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/highlight_mention.dart';
import 'package:splach/widgets/highlight_text.dart';

class ChatUserMessage extends StatelessWidget {
  final Message message;
  final VoidCallback onMessageFailed;

  const ChatUserMessage({
    super.key,
    required this.message,
    required this.onMessageFailed,
  });

  final double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: ThemeColors.primary,
                border: Border.all(
                  color: ThemeColors.grey2,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.zero,
                  topLeft: Radius.circular(_borderRadius),
                  bottomLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.replyMessage != null) ...[
                    if (message.replyMessage!.content != null ||
                        message.replyMessage!.imageUrl != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeColors.grey1,
                          border: Border.all(
                            color: ThemeColors.grey2,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.zero,
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      message.replyMessage?.sender?.nickname
                                              .toNickname() ??
                                          'user',
                                      style: ThemeTypography.semiBold12.apply(
                                        color: ThemeColors.primary,
                                      ),
                                    ),
                                    if (message.private) ...[
                                      const PrivateMessageSign(),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (message.replyMessage!.imageUrl !=
                                            null &&
                                        message.replyMessage!.imageUrl!
                                            .isNotEmpty) ...[
                                      ChatImage(
                                        image: message.replyMessage!.imageUrl!,
                                        maxWidth: 64,
                                        maxHeight: 64,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    if (message.replyMessage!.content !=
                                        null) ...[
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 75,
                                          maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (message.replyMessage!
                                                              .imageUrl !=
                                                          null
                                                      ? 0.55
                                                      : 0.65) -
                                              32,
                                        ),
                                        child: HighlightText(
                                          message.replyMessage!.content!,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                  if ((message.imageUrl != null &&
                          message.imageUrl!.isNotEmpty) ||
                      message.temporaryImage != null) ...[
                    ChatImage(
                      image: message.imageUrl!,
                      temporaryImage: message.temporaryImage,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (message.content != null) ...[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 75,
                        maxWidth: MediaQuery.of(context).size.width * 0.65 - 32,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: ThemeTypography.regular14.apply(
                            color: Colors.white,
                          ),
                          children: highlightMention(
                            message.content!,
                            isFromUser: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${message.createdAt.toTimeString()} ago',
                        style: ThemeTypography.regular9.apply(
                          color: ThemeColors.light,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${message.status}',
                        style: ThemeTypography.regular9.apply(
                          color: ThemeColors.light,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (message.status == MessageStatus.error) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onMessageFailed,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Failed to send message. Tap here to try again.',
                        style: ThemeTypography.regular12.apply(
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ],
    );
  }
}
