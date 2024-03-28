import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum AppNotificationType {
  followRequest,
  newFollower,
  mention,
  newChat,
}

class AppNotification {
  final String content;
  final String relatedId;
  final AppNotificationType notificationType;
  final DateTime createdAt;
  final DateTime updatedAt;

  User? sender;

  AppNotification({
    required this.updatedAt,
    required this.createdAt,
    required this.content,
    required this.relatedId,
    this.notificationType = AppNotificationType.followRequest,
  });

  bool get isFollowRequest =>
      notificationType == AppNotificationType.followRequest;
}
