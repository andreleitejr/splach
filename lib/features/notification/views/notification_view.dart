import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/notification/controllers/notification_controller.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/avatar_image.dart';
import 'package:splach/widgets/highlight_text.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class NotificationView extends StatelessWidget {
  final controller = Get.put(NotificationController());
  final bool showLeading;

  NotificationView({
    Key? key,
    this.showLeading = false,
  }) : super(key: key);

  final UserRepository _userRepository = Get.find();

  Future<User?> _getUser(String userId) async {
    return await _userRepository.get(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        showLeading: showLeading,
        title: 'Notificações',
      ),
      body: ListView.builder(
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return NotificationItem(
            onNotificationTap: () async {
              final user = await _getUser(notification.relatedId);
              if (user != null) {
                Get.to(
                  () => UserProfileView(user: user),
                );
              }
            },
            notification: notification,
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onNotificationTap;

  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onNotificationTap,
      leading: notification.image != null
          ? AvatarImage(
              image: notification.image!,
              width: 36,
              height: 36,
            )
          : null,
      title: HighlightText(notification.content),
      // subtitle: Text('De: ${notification.senderId}'),
      trailing: Text(notification.updatedAt.toTimeString()),
    );
  }
}
