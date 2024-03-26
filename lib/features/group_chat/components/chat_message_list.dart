import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/components/chat_image_input.dart';
import 'package:splach/features/group_chat/components/chat_user_message.dart';
import 'package:splach/features/group_chat/controllers/group_chat_controller.dart';
import 'package:splach/features/group_chat/models/message.dart';
import 'package:splach/features/rating/widgets/rating_bottom_sheet.dart';
import 'package:splach/features/refactor/models/report_message_topic.dart';
import 'package:splach/features/refactor/widgets/report_message_bottom_sheet.dart';
import 'package:splach/features/user/components/user_profile_header.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/widgets/custom_list_tile.dart';

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
                          onHorizontalDragEnd: () => _replyMessage(message),
                          onButtonTap: () => _showBottomSheet(message),
                          onAvatarTap: () => _goToUserPage(message),
                          onAvatarLongPress: () => _showBottomSheet(message),
                          onTitleTap: () => _goToUserPage(message),
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

  void _replyMessage(Message message) {
    focus.requestFocus();
    controller.replyMessage.value = message;
    controller.recipients.add(message.senderId);
  }

  void _reportMessage(String messageId) {
    Get.bottomSheet(
      ReportMessageBottomSheet<ReportMessageTopic>(
        items: reportMessageTopics,
        onItemSelected: (selectedItem) async {
          controller.reportMessage(
            messageId,
            selectedItem.title,
            '',
          );
          focus.unfocus();
        },
      ),
      enableDrag: true,
    );
  }

  void _rate(String ratedId, String ratedTitle) {
    Get.bottomSheet(
      RatingBottomSheet(
        ratedId: ratedId,
        ratedTitle: ratedTitle,
      ),
      enableDrag: true,
    );
  }

  void _showBottomSheet(Message message) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(
              image: message.sender!.image,
              title: message.sender!.nickname,
              description: message.content!,
            ),
            CustomListTile(
              title: 'About this user',
              leading: const Icon(Icons.person_2_outlined),
              onTap: () => _goToUserPage(message),
            ),
            CustomListTile(
              title: 'Rate this user',
              leading: const Icon(Icons.star_outline),
              onTap: () {
                Get.back();
                _rate(
                  message.senderId,
                  '@${message.sender?.nickname}',
                );
              },
            ),
            CustomListTile(
              title: 'Report message',
              leading: const Icon(
                Icons.block,
                color: Colors.redAccent,
              ),
              onTap: () {
                Get.back();
                _reportMessage(message.id!);
              },
              textColor: Colors.red,
            ),
          ],
        ),
      ),
      enableDrag: true,
    );
  }

  Future<void> _goToUserPage(Message message) async {
    final user = await controller.getUser(message.senderId);
    if (user != null) {
      Get.to(() => UserProfileView(user: user));
    }
  }
}
