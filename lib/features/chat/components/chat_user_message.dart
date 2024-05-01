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
    final showMessageReply = message.replyMessage != null;

    final hasImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;

    final hasTemporaryImage = message.temporaryImage != null;

    final showMessageImage = hasImage || hasTemporaryImage;

    final showMessageContent = message.content != null;
    final showMessageError = message.status == MessageStatus.error;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            Container(
              constraints: const BoxConstraints(
                minWidth: 75,
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
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showMessageReply) _buildMessageReply(context),
                      if (showMessageImage) _buildMessageImage(),
                      if (showMessageContent) _buildMessageContent(context),
                      const SizedBox(height: 12),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildMessageTimestamp(),
                  ),
                ],
              ),
            ),
            if (showMessageError) ...[
              const SizedBox(height: 6),
              _buildMessageError(),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildMessageReply(BuildContext context) {
    final reply = message.replyMessage!;
    final content = reply.content;
    final image = reply.imageUrl;
    final nickname = (reply.sender?.nickname ?? 'user').toNickname();

    final replyContent = '$nickname $content';

    final showImage = image != null && image.isNotEmpty;

    final showContent = content != null;

    if (showContent || showImage) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
        child: Column(
          children: [
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
                children: [
                  if (showImage) ...[
                    ChatImage(
                      image: message.replyMessage!.imageUrl!,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (showContent) ...[
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .65,
                      ),
                      child: HighlightText(
                        replyContent,
                        maxLines: 3,
                        isReply: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildMessageImage() {
    return Column(
      children: [
        const SizedBox(height: 16),
        ChatImage(
          maxHeight: 120,
          image: message.imageUrl!,
          temporaryImage: message.temporaryImage,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .65,
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
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
    );
  }

  Widget _buildMessageTimestamp() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        '${message.createdAt.toTimeString()} ago',
        style: ThemeTypography.regular8.apply(
          color: ThemeColors.light,
        ),
      ),
    );
  }

  Widget _buildMessageError() {
    return GestureDetector(
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
    );
  }
}
