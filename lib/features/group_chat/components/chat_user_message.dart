import 'package:flutter/material.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';

import 'chat_highlight_mention.dart';

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
                    // Row(
                    //   // mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     // if (message.replyId != null) ...[
                    //     //   AvatarImage(
                    //     //     image: message.replyMessage!.sender!.image,
                    //     //     width: 32,
                    //     //     height: 32,
                    //     //   ),
                    //     //   const SizedBox(width: 8),
                    //     // ],
                    //     Text(
                    //       'Answering',
                    //       style: ThemeTypography.regular12.apply(
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 4,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 2),
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
                              Text(
                                '@${message.replyMessage?.sender?.nickname}',
                                style: ThemeTypography.semiBold12.apply(
                                  color: ThemeColors.primary,
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 75,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.65 -
                                          32,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: ThemeTypography.regular14.apply(
                                      color: Colors.black,
                                    ),
                                    children: highlightMentions(
                                      message.replyMessage!.content,
                                    ),
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                    const SizedBox(height: 16),
                  ],
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
                          message.content,
                        ),
                      ),
                    ),
                  ),
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
