import 'package:flutter/material.dart';
import 'package:splach/features/chat/components/chat_image.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/chat/widgets/private_message_sign.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/highlight_mention.dart';
import 'package:splach/widgets/highlight_text.dart';

class ChatSenderMessage extends StatelessWidget {
  final Message message;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onHorizontalDragEnd;
  final VoidCallback? onLongPress;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onTitleTap;

  const ChatSenderMessage({
    super.key,
    required this.message,
    this.onDoubleTap,
    this.onHorizontalDragEnd,
    this.onLongPress,
    this.onAvatarTap,
    this.onTitleTap,
  });

  final double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    if (message.isPrivate && !message.isReplied) {
      return Container();
    }

    final showMessageReply = message.replyMessage != null;

    final showMessageImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;

    final showMessageContent = message.content != null;

    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onHorizontalDragEnd: (_) {
        onHorizontalDragEnd?.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.sender != null) ...[
            GestureDetector(
              onTap: onAvatarTap,
              child: AvatarImage(image: message.sender!.image),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            decoration: BoxDecoration(
              color: message.isHighlighted ? null : Colors.white,
              gradient: message.isHighlighted
                  ? LinearGradient(
                      colors: [
                        const Color(0xFFD7B7FF).withOpacity(.18),
                        const Color(0xFFA8CCFF).withOpacity(.18),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              border: Border.all(
                color: message.isHighlighted
                    ? ThemeColors.primary
                    : ThemeColors.grey2,
                width: 0.5,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(_borderRadius),
                bottomLeft: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageHeader(),
                    // const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  Widget _buildMessageHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTitleTap,
            child: Text(
              message.sender?.nickname.toNickname() ?? 'user'.toNickname(),
              style: ThemeTypography.semiBold12.copyWith(
                color: ThemeColors.primary,
              ),
            ),
          ),
          if (message.private) ...[
            const SizedBox(width: 4),
            const PrivateMessageSign(),
          ],
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                  topLeft: Radius.zero,
                  topRight: Radius.circular(8),
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
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: RichText(
        text: TextSpan(
          style: ThemeTypography.regular14.apply(
            color: Colors.black,
          ),
          children: highlightMention(
            message.content!,
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
          color: message.isPrivate ? ThemeColors.tertiary : ThemeColors.grey4,
        ),
      ),
    );
  }
}
