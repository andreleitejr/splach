import 'package:flutter/material.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';

class ChatParticipantMentionList extends StatelessWidget {
  final ChatController controller;
  final Function(Participant) onUserSelected;
  final bool isImageInput;

  const ChatParticipantMentionList({
    Key? key,
    required this.controller,
    required this.onUserSelected,
    this.isImageInput = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 200,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        shrinkWrap: true,
        itemCount: controller.participants.length,
        itemBuilder: (context, index) {
          final participant = controller.participants[index];

          if (participant.id == controller.user.id) {
            return Container();
          }

          return Container(
            decoration: participant != controller.participants.last
                ? const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: ThemeColors.grey2,
                      ),
                    ),
                  )
                : null,
            child: ListTile(
              leading: AvatarImage(
                image: participant.image,
              ),
              title: Text(
                participant.nickname.toNickname(),
                style: ThemeTypography.regular14.apply(
                  color: isImageInput ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                onUserSelected(participant);
              },
            ),
          );
        },
      ),
    );
  }
}
