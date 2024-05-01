import 'package:flutter/material.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_icons.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/custom_icon.dart';
import 'package:splach/widgets/highlight_mention.dart';
import 'package:splach/widgets/highlight_text.dart';

import 'chat_image.dart';

class ChatReplyMessage extends StatelessWidget {
  final Message replyMessage;
  final VoidCallback onClose;
  final bool isPrivate;

  const ChatReplyMessage({
    super.key,
    required this.replyMessage,
    required this.onClose,
    this.isPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyMessage.content != null) ...[
            Container(
              decoration: BoxDecoration(
                color: isPrivate ? null : ThemeColors.grey1,
                gradient: isPrivate
                    ? LinearGradient(
                        colors: [
                          const Color(0xFFA8CCFF).withOpacity(0.25),
                          const Color(0xFFD7B7FF).withOpacity(0.25),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      )
                    : null,
                border: Border.all(
                  color: isPrivate ? ThemeColors.primary : ThemeColors.grey2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  AvatarImage(
                    image: replyMessage.sender!.image,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (replyMessage.imageUrl != null &&
                                replyMessage.imageUrl!.isNotEmpty) ...[
                              ChatImage(
                                image: replyMessage.imageUrl!,
                                maxHeight: 64,
                                maxWidth: 64,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: _buildContent(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final answeringText = isPrivate ? 'asnwering' : 'Asnwering';
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (replyMessage.sender != null) ...[
          if (isPrivate) ...[
            const CustomIcon(
              ThemeIcons.lock,
              height: 14,
              color: ThemeColors.primary,
            ),
            const SizedBox(width: 2),
            Text(
              'Privately',
              style: ThemeTypography.semiBold14.apply(
                color: ThemeColors.primary,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: HighlightText(
                '$answeringText @${replyMessage.sender!.nickname}'),
          ),
        ],
        IconButton(
          onPressed: onClose,
          constraints: const BoxConstraints(
            maxHeight: 32,
          ),
          icon: const CustomIcon(
            ThemeIcons.close,
            // height: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return ConstrainedBox(
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
            replyMessage.content!,
          ),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
