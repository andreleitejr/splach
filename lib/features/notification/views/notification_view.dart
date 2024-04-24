import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/notification/components/notification_list_item.dart';
import 'package:splach/features/notification/controllers/notification_controller.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/features/user/views/user_profile_view.dart';
import 'package:splach/widgets/top_navigation_bar.dart';

class NotificationView extends StatelessWidget {
  final controller = Get.put(NotificationController());
  final bool showLeading;

  NotificationView({
    Key? key,
    this.showLeading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        showLeading: showLeading,
        title: 'Notifications',
      ),
      body: ListView.builder(
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return NotificationItem(
            onNotificationTap: () async {
              print('################### NOTIFICATION RELATED ID: ${notification.relatedId}');
              final user = await controller.getUser(
                notification.relatedId,
              );
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
