import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_image.dart';
import 'package:splach/features/group_chat/models/message.dart';
import 'package:splach/features/group_chat/widgets/private_message_sign.dart';
import 'package:splach/features/refactor/models/report_message_topic.dart';
import 'package:splach/features/refactor/widgets/report_message_bottom_sheet.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/custom_bottom_sheet.dart';
import 'chat_highlight_mention.dart';

class ChatSenderMessage extends StatelessWidget {
  final Message message;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onHorizontalDragEnd;
  final VoidCallback? onButtonTap;

  const ChatSenderMessage({
    super.key,
    required this.message,
    this.onDoubleTap,
    this.onHorizontalDragEnd,
    this.onButtonTap,
  });

  final double _borderRadius = 12;

  @override
  Widget build(BuildContext context) {
    final userId = Get.find<User>().id;

    final isReplied = message.recipients!.contains(userId);

    if (message.private && !isReplied) {
      return Container();
    }

    final isHighlighted = message.private && isReplied;

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
            AvatarImage(image: message.sender!.image),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 8,
            ),
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
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '@${message.sender?.nickname ?? 'user'}',
                            style: ThemeTypography.semiBold12.copyWith(
                              color: ThemeColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (message.private) ...[
                      const PrivateMessageSign(),
                    ],
                    IconButton(
                      onPressed: () {
                        onButtonTap?.call();
                      },
                      icon: Icon(Icons.more_horiz),
                    )
                  ],
                ),
                if (message.replyMessage != null) ...[
                  const SizedBox(height: 2),
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
                                '@${message.replyMessage?.sender?.nickname}',
                                style: ThemeTypography.semiBold12.apply(
                                  color: ThemeColors.primary,
                                ),
                              ),
                              if (message.replyMessage!.image != null &&
                                  message.replyMessage!.image!.isNotEmpty) ...[
                                ChatImage(image: message.replyMessage!.image!),
                              ],
                              if (message.replyMessage!.content != null) ...[
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 75,
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                                0.65 -
                                            32,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      style: ThemeTypography.regular14.apply(
                                        color: Colors.black,
                                      ),
                                      children: highlightMentions(
                                        message.replyMessage!.content!,
                                      ),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              // const SizedBox(height: 8),
                              // Text(
                              //   '${replyMessage.createdAt.toTimeString()} ago',
                              //   style: ThemeTypography.regular9.apply(
                              //     color: ThemeColors.grey4,
                              //   ),
                              //   textAlign: TextAlign.right,
                              // ),
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
                        children: highlightMentions(
                          message.content!,
                        ),
                      ),
                    ),
                  ),
                ],
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
