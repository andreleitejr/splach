import 'package:flutter/material.dart';
import 'package:splach/features/chat/models/group_chat.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_icons.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/custom_icon.dart';

class ChatLargeListItem extends StatelessWidget {
  final GroupChat chat;
  final VoidCallback onPressed;

  const ChatLargeListItem({
    super.key,
    required this.chat,
    required this.onPressed,
  });

  final double userAvatarSize = 42;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                  height: 225,
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
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0),
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
                      children: [_participantList()],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    chat.title.capitalizeFirstLetter(),
                    style: ThemeTypography.semiBold16,
                  ),
                ),
                Row(
                  children: [
                    const CustomIcon(
                      ThemeIcons.pin,
                      color: ThemeColors.grey4,
                      height: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${chat.distance!.formatDistance} distance',
                      style: ThemeTypography.regular14.apply(
                        color: ThemeColors.grey4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              chat.description,
              style: ThemeTypography.regular14,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _participantList() {
    for (var i = 0; i < chat.participants.length; i++) {
      if (i < 5) {
        return Positioned(
          top: 0,
          left: i != 0 ? (i * (userAvatarSize - 4)) : 0,
          child: i == 4
              ? _totalParticipantsWidget()
              : AvatarImage(image: chat.participants[i].image),
        );
      }
    }
    return Container();
  }

  Widget _totalParticipantsWidget() {
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
        '+${chat.participants.length - 3}',
        style: ThemeTypography.semiBold12.apply(
          color: Colors.white,
        ),
      ),
    );
  }
}
