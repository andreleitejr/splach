import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/components/chat_image_input.dart';
import 'package:splach/features/chat/components/chat_user_message.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/report/models/report_message_topic.dart';
import 'package:splach/features/report/widgets/report_message_bottom_sheet.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/flat_button.dart';

import 'chat_sender_message.dart';
import 'chat_system_message.dart';

class ChatMessageList extends StatelessWidget {
  final ChatController controller;
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
    if (message.sender != null) {
      focus.requestFocus();
      controller.replyMessage.value = message;
      controller.recipients.add(message.senderId);
    } else {
      Get.snackbar(
        'You can\'t reply',
        'User is not in the room anymore.',
        duration: const Duration(seconds: 2),
        backgroundColor: ThemeColors.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
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

  // void _rate(String ratedId, String? ratedTitle) {
  //   Get.bottomSheet(
  //     RatingBottomSheet(
  //       ratedId: ratedId,
  //       ratedTitle: ratedTitle ?? 'User not found',
  //     ),
  //     enableDrag: true,
  //   );
  // }

  void _showBottomSheet(Message message) {
    controller.checkRatingValue(message.senderId);
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.tertiary.withOpacity(0.25),
              spreadRadius: -8,
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    height: 6,
                    width: 36,
                    decoration: BoxDecoration(
                      color: ThemeColors.grey2,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: MemoryImage(
                                  base64Decode(message.sender!.image),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // if (user.rating != null)
                          //   Row(
                          //     children: [
                          //       const Icon(Icons.star),
                          //       Text(user.rating!.toString()),
                          //     ],
                          //   ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.sender!.nickname.toNickname(),
                                style: ThemeTypography.semiBold16,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                message.content!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeTypography.regular14.apply(
                                  color: ThemeColors.grey4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildRatingStars(),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () {
                        controller.rate(message.senderId);
                        Get.back();
                      },
                      actionText: 'Rate this user',
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 16),
            // Container(
            //   width: double.infinity,
            //   height: 1,
            //   color: ThemeColors.grey2,
            // ),
            // const SizedBox(height: 16),
            // CustomListTile(
            //   title: 'About this user',
            //   leading: const Icon(Icons.person_2_outlined),
            //   onTap: () => _goToUserPage(message),
            // ),
            // CustomListTile(
            //   title: 'Rate this user',
            //   leading: const Icon(Icons.star_outline),
            //   onTap: () {
            //     Get.back();
            //     _rate(
            //       message.senderId,
            //       message.sender?.nickname.toNickname(),
            //     );
            //   },
            // ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Get.back();
                _reportMessage(message.id!);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.block,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Report message',
                    style: ThemeTypography.medium14.apply(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // CustomListTile(
            //   title: 'Report message',
            //   leading: const Icon(
            //     Icons.block,
            //     color: Colors.redAccent,
            //   ),
            //   onTap: () {
            //     Get.back();
            //     _reportMessage(message.id!);
            //   },
            //   textColor: Colors.red,
            // ),
            // const SizedBox(height: 16),
          ],
        ),
      ),
      enableDrag: true,
    );
  }

  Widget _buildRatingStars() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          5,
          (index) => IconButton(
            onPressed: () {
              controller.ratingValue.value = index + 1;
            },
            icon: Icon(
              index < controller.ratingValue.value
                  ? Icons.star
                  : Icons.star_border,
              color: Colors.orange,
              size: 36,
            ),
          ),
        ),
      );
    });
  }

  Future<void> _goToUserPage(Message message) async {
    final user = await controller.getUser(message.senderId);
    if (user != null) {
      Get.to(() => UserProfileView(user: user));
    }
  }
}
