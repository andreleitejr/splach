import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';

class ChatLargeListItem extends StatelessWidget {
  final GroupChat chat;
  final VoidCallback onPressed;

  const ChatLargeListItem({
    super.key,
    required this.chat,
    required this.onPressed,
  });

  final double userAvatarSize = 36;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 175,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        chat.images.first,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: SizedBox(
                    height: userAvatarSize,
                    width: userAvatarSize * 5,
                    child: Stack(
                      children: [
                        for (var i = 0; i < chat.users.length; i++) ...[
                          if (i < 5) ...[
                            Positioned(
                              top: 0,
                              left: i != 0 ? (i * (userAvatarSize - 4)) : 0,
                              child: _getChatUserAvatar(i),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              chat.title,
              style: ThemeTypography.semiBold14,
            ),
            const SizedBox(height: 8),
            Text(
              chat.description,
              style: ThemeTypography.regular12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.pin_drop_outlined,
                  color: ThemeColors.grey4,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  '${chat.distance!.formatDistance} distance',
                  style: ThemeTypography.regular12.apply(
                    color: ThemeColors.grey4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChatUserAvatar(int index) {
    if (index == 4) {
      return Container(
        height: userAvatarSize,
        width: userAvatarSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFF522BBD).withOpacity(0.85),
              const Color(0xFFD3BAF4).withOpacity(0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Text(
          '+${chat.participants.length - 5}',
          style: ThemeTypography.semiBold12.apply(
            color: Colors.white,
          ),
        ),
      );
    }
    return Container(
      height: userAvatarSize,
      width: userAvatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColors.grey3,
        image: DecorationImage(
          image: MemoryImage(
            base64Decode(chat.users[index].image),
          ),
        ),
        border: Border.all(
          color: Colors.white,
        ),
      ),
    );
  }
}
