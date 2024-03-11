import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/themes/theme_colors.dart';

import 'chat_message_box.dart';
import 'chat_system_message.dart';

class ChatMessageList extends StatelessWidget {
  final GroupChatController controller;

  const ChatMessageList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                controller.scrollListener();
                return false;
              },
              child: ListView.builder(
                controller: controller.scrollController,
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return Column(
                    children: [
                      message.isFromSystem
                          ? ChatSystemMessage(message: message)
                          : ChatMessageBox(message: message),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            Obx(() {
              if (controller.showButton.isTrue) {
                return backToBottomButton();
              }
              return Container();
            }),
          ],
        ),
      ),
    );
  }

  Widget backToBottomButton() {
    return Positioned(
      right: 24,
      bottom: 24,
      child: GestureDetector(
        onTap: () => controller.scrollToBottom(),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: ThemeColors.tertiary.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.tertiary.withOpacity(0.25),
                spreadRadius: 4,
                blurRadius: 20,
                offset: const Offset(-2, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.keyboard_double_arrow_down,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
