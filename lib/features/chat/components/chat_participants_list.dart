import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/avatar_image.dart';

class ChatParticipantsList extends StatelessWidget {
  final ChatController controller;

  const ChatParticipantsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.participants.isEmpty) {
        return Container();
      }

      return SizedBox(
        height: 64,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          itemCount: controller.participants.length,
          itemBuilder: (BuildContext context, int index) {
            final participant = controller.participants[index];
            return _buildParticipantAvatar(participant);
          },
        ),
      );
    });
  }

  Widget _buildParticipantAvatar(Participant participant) {
    return GestureDetector(
      onTap: () async {
        final user = await controller.getUser(participant.id!);
        if (user != null) {
          Get.to(() => UserProfileView(user: user));
        }
      },
      child: Container(
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
      ),
    );
  }
}
