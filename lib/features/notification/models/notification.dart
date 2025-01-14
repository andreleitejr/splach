import 'package:splach/features/user/models/user.dart';

enum AppNotificationType {
  rating,
  mention,
}

class AppNotification {
  final String id;
  final String content;
  final String relatedId;
  final AppNotificationType notificationType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? image;

  User? sender;

  AppNotification({
    required this.id,
    required this.updatedAt,
    required this.createdAt,
    required this.content,
    required this.relatedId,
    this.notificationType = AppNotificationType.rating,
    this.image,
  });
}
