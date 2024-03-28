import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/views/chat_info_view.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/views/chat_participants_view.dart';

class ChatTopNavigationBar extends StatelessWidget {
  final ChatController controller;

  const ChatTopNavigationBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.to(
              () => ChatParticipantsView(
                users: controller.participants,
              ),
            ),
            icon: const Icon(
              Icons.people_outline,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.groupChat.messages = controller.messages
                  .where(
                    (message) => message.image != null,
                  )
                  .toList();

              Get.to(
                () => ChatInfoView(
                  chat: controller.groupChat,
                ),
              );
            },
            icon: const Icon(
              Icons.image_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
