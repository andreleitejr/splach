import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/utils/extensions.dart';

class NotificationView extends StatelessWidget {
  final List<AppNotification> notifications;

  NotificationView({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  final UserRepository _userRepository = Get.find();

  Future<User?> _getUser(String userId) async {
    return await _userRepository.get(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
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
      title: Text(notification.content),
      // subtitle: Text('De: ${notification.senderId}'),
      trailing: Text(notification.createdAt.toTimeString()),
    );
  }
}
