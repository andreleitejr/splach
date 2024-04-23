
import 'package:flutter/material.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/themes/theme_colors.dart';
import 'package:splach/themes/theme_typography.dart';
import 'package:splach/utils/extensions.dart';
import 'package:splach/widgets/highlight_text.dart';

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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ThemeColors.grey2,
          ),
        ),
      ),
      child: ListTile(
        onTap: onNotificationTap,
        leading: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ThemeColors.grey3,
            image: DecorationImage(
              image: NetworkImage(notification.image!),
            ),
            border: Border.all(
              color: Colors.white,
              width: 2,
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
        ),
        title: HighlightText(notification.content),
        subtitle: Text(
          notification.updatedAt.toTimeString(),
          style: ThemeTypography.regular12.apply(
            color: ThemeColors.grey4,
          ),
        ),
      ),
    );
  }
}
