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
  final VoidCallback? onButtonTap;
  final VoidCallback? onAvatarLongPress;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onTitleTap;

  const ChatSenderMessage({
    super.key,
    required this.message,
    this.onDoubleTap,
    this.onHorizontalDragEnd,
    this.onButtonTap,
    this.onAvatarLongPress,
    this.onAvatarTap,
    this.onTitleTap,
  });

  final double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    final userId = Get.find<User>().id;

    final isReplied = message.recipients!.contains(userId);

    if (message.private && !isReplied) {
      return Container();
    }

    final isHighlighted = message.private || isReplied;

    return GestureDetector(
      onDoubleTap: onDoubleTap,
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
              onLongPress: onAvatarLongPress,
              child: AvatarImage(image: message.sender!.image),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlighted ? ThemeColors.grey1 : Colors.white,
              border: Border.all(
                color:
                    isHighlighted ? ThemeColors.secondary : ThemeColors.grey2,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onTitleTap,
                      child: Text(
                        message.sender?.nickname.toNickname() ?? 'user',
                        style: ThemeTypography.semiBold12.copyWith(
                          color: ThemeColors.primary,
                        ),
                      ),
                    ),
                    if (message.private) ...[
                      const SizedBox(width: 4),
                      const PrivateMessageSign(),
                    ],
                    GestureDetector(
                      onTap: () {
                        onButtonTap?.call();
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 24,
                          maxWidth: 24,
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                if (message.replyMessage != null) ...[
                  // const SizedBox(height: 2),
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
                          topLeft: Radius.zero,
                          topRight: Radius.circular(8),
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
                              Text(
                                message.replyMessage?.sender?.nickname
                                        .toNickname() ??
                                    '',
                                style: ThemeTypography.semiBold12.apply(
                                  color: ThemeColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (message.replyMessage!.imageUrl != null &&
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
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
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
                  const SizedBox(height: 8),
                ],
                if ((message.imageUrl != null &&
                        message.imageUrl!.isNotEmpty) ||
                    message.temporaryImage != null) ...[
                  ChatImage(
                    image: message.imageUrl!,
                    temporaryImage: message.temporaryImage,
                  ),
                  const SizedBox(height: 4),
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
                          color: Colors.black,
                        ),
                        children: highlightMention(
                          message.content!,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
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
