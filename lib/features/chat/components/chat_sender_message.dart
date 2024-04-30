import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/components/chat_image.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/chat/widgets/private_message_sign.dart';
import 'package:splach/features/user/models/user.dart';
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

    final hasImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;

    final hasTemporaryImage = message.temporaryImage != null;

    final showMessageImage = hasImage || hasTemporaryImage;

    final showMessageContent = message.content != null;

    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onHorizontalDragEnd: (_) {
        onHorizontalDragEnd?.call();
      },
      // onHorizontalDragStart: (_) {
      //   onLongPress?.call();
      // },
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
            padding: const EdgeInsets.all(8),
            // constraints: BoxConstraints(
            //   minWidth: 75,
            //   maxWidth: MediaQuery.of(context).size.width * .65,
            // ),
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
                    const SizedBox(height: 4),
                    if (showMessageReply) _buildMessageReply(),
                    if (showMessageImage) _buildMessageImage(),
                    if (showMessageContent) _buildMessageContent(),
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
    return Row(
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
        // GestureDetector(
        //   onTap: () {
        //     onMoreButtonTap?.call();
        //   },
        //   child: Container(
        //     constraints: const BoxConstraints(
        //       maxHeight: 24,
        //       maxWidth: 24,
        //     ),
        //     child: const Icon(
        //       Icons.more_horiz,
        //       size: 24,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildMessageReply() {
    final showImage = message.replyMessage!.imageUrl != null &&
        message.replyMessage!.imageUrl!.isNotEmpty;

    final showContent = message.replyMessage!.content != null;

    final content =
        '${message.replyMessage?.sender?.nickname.toNickname() ?? 'user'.toNickname()}'
        ' ${message.replyMessage!.content!}';
    if (showContent || showImage) {
      return Column(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      HighlightText(content),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    }
    return Container();
  }

  Widget _buildMessageImage() {
    return Column(
      children: [
        ChatImage(
          image: message.imageUrl!,
          temporaryImage: message.temporaryImage,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildMessageContent() {
    return RichText(
      text: TextSpan(
        style: ThemeTypography.regular14.apply(
          color: Colors.black,
        ),
        children: highlightMention(
          message.content!,
        ),
      ),
    );
  }

  Widget _buildMessageTimestamp() {
    return Text(
      '${message.createdAt.toTimeString()} ago',
      style: ThemeTypography.regular8.apply(
        color: message.isPrivate ? ThemeColors.tertiary : ThemeColors.grey4,
      ),
    );
  }
}
