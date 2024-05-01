import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/controllers/chat_controller.dart';
import 'package:splach/features/chat/views/chat_info_view.dart';
import 'package:splach/features/chat/views/chat_participants_view.dart';
import 'package:splach/features/notification/views/notification_view.dart';
import 'package:splach/themes/theme_icons.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/widgets/custom_icon.dart';

class ChatTopNavigationBar extends StatelessWidget {
  final ChatController controller;

  const ChatTopNavigationBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const CustomIcon(
                ThemeIcons.arrowBack,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(
            () => ChatParticipantsView(
              users: controller.participants,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: CustomIcon(
              ThemeIcons.people,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
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
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: CustomIcon(
              ThemeIcons.image,
            ),
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
              padding: const EdgeInsets.fromLTRB(6, 0, 16, 0),
              child: badges.Badge(
                showBadge:
                    controller.notificationController.notifications.isNotEmpty,
                position: badges.BadgePosition.topEnd(
                  top: -8,
                  end: -5,
                ),
                badgeContent: Text(
                  controller.notificationController.notifications.length
                      .toString(),
                  style: ThemeTypography.semiBold12.apply(
                    color: Colors.white,
                  ),
                ),
                child: const CustomIcon(
                  ThemeIcons.bell,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
