import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_image_input.dart';
import 'package:splach/features/group_chat/components/chat_user_message.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/models/message.dart';
import 'package:splach/themes/theme_colors.dart';

import 'chat_sender_message.dart';
import 'chat_system_message.dart';

class ChatMessageList extends StatelessWidget {
  final GroupChatController controller;
  final FocusNode focus;

  const ChatMessageList({
    super.key,
    required this.controller,
    required this.focus,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final messages = controller.messages;
      return Expanded(
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  if (message.replyId != null) {
                    message.replyMessage = messages.firstWhereOrNull(
                      (m) {
                        return message.replyId == m.id;
                      },
                    );
                  }


                  return Column(
                    children: [
                      if (message.isFromSystem) ...[
                        ChatSystemMessage(
                          message: message,
                        )
                      ] else if (message.isFromUser) ...[
                        ChatUserMessage(
                          message: message,
                        ),
                      ] else ...[
                        ChatSenderMessage(
                          message: message,
                          onHorizontalDragEnd: () => replyMessage(message),
                        ),
                      ],
                      SizedBox(
                        height: message.isFromSystem ? 12 : 8,
                      ),
                    ],
                  );
                },
              ),
            ),
            // Obx(() {
            //   if (controller.mentionIndexes.isNotEmpty) {
            //     return goToMentionMessageButton();
            //   }
            //   return Container();
            // }),
            Obx(() {
              if (controller.showButton.isTrue) {
                return backToBottomButton();
              }
              return Container();
            }),
          ],
        ),
      );
    });
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

  Widget goToMentionMessageButton() {
    return Positioned(
      right: 24,
      bottom: 24,
      child: GestureDetector(
        onTap: () => controller.scrollToMessageIndex(),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: ThemeColors.secondary.withOpacity(0.85),
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
            Icons.message_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void replyMessage(Message message) {
    focus.requestFocus();
    controller.replyMessage.value = message;
    print('Requesting focus!');
  }
}
