import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splach/features/chat/components/chat_image.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/chat/widgets/private_message_sign.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/highlight_text.dart';

class ChatUserMessage extends StatelessWidget {
  final Message message;

  const ChatUserMessage({
    super.key,
    required this.message,
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
                        message.replyMessage!.image != null) ...[
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
                                      '@${message.replyMessage?.sender?.nickname ?? 'user'}',
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
                                    if (message.replyMessage!.image != null &&
                                        message.replyMessage!.image!
                                            .isNotEmpty) ...[
                                      ChatImage(
                                        image: message.replyMessage!.image!,
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
                                                              .image !=
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
                  if (message.image != null && message.image!.isNotEmpty) ...[
                    ChatImage(image: message.image!),
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
                          children: highlightMentions(
                            message.content!,
                            isFromUser: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${message.createdAt.toTimeString()} ago',
                    style: ThemeTypography.regular9.apply(
                      color: ThemeColors.light,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
