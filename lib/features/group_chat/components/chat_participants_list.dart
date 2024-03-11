import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/avatar_image.dart';

class ChatParticipantsList extends StatelessWidget {
  final GroupChatController controller;

  const ChatParticipantsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.users.isEmpty) {
        return Container();
      }

      return SizedBox(
        height: 64,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          itemCount: controller.users.length,
          itemBuilder: (BuildContext context, int index) {
            final participant = controller.users[index];
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarImage(
                    image: participant.image,
                  ),
                  Text(
                    participant.nickname,
                    style: ThemeTypography.regular9,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
