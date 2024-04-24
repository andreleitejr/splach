import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/views/chat_info_view.dart';
import 'package:splach/features/chat/views/chat_participants_view.dart';
import 'package:splach/features/notification/views/notification_view.dart';
import 'package:splach/themes/theme_typography.dart';

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
              controller.chat.messages = controller.messages
                  .where(
                    (message) => message.imageUrl != null,
                  )
                  .toList();

              Get.to(
                () => ChatInfoView(
                  chat: controller.chat,
                ),
              );
            },
            icon: const Icon(
              Icons.image_outlined,
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () => Get.to(
                () => NotificationView(
                  controller: controller.notificationController,
                  showLeading: true,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: badges.Badge(
                  showBadge: controller
                      .notificationController.notifications.isNotEmpty,
                  position: badges.BadgePosition.topEnd(
                    top: -5,
                    end: -5,
                  ),
                  badgeContent: Text(
                    controller.notificationController.notifications.length
                        .toString(),
                    style: ThemeTypography.semiBold12.apply(
                      color: Colors.white,
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
