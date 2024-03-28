import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/features/relationship/repositories/relationship_repository.dart';
import 'package:splach/features/user/models/user.dart';

class NotificationController extends GetxController {
  final User user = Get.find();

  final _ratingRepository = Get.put(RatingRepository());

  final notifications = <AppNotification>[].obs;

  final ratings = <Rating>[].obs;

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;

    _listenToRelationshipsStream();

    loading.value = false;
  }

  void _listenToRelationshipsStream() {
    _ratingRepository.streamAll(userId: user.id).listen((newRatings) {
      final userRatings = newRatings.where((rating) {
        return rating.type == RatingType.user;
      }).toList();

      debugPrint(
          'DEBUG | Ratings ${userRatings.map((e) => e.ratedId).toList()}');
      ratings.assignAll(userRatings);
      ratings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (ratings.isNotEmpty) _createRatingNotification(ratings.first);
    });
  }

  void _createRatingNotification(Rating rating) {
    final notification = AppNotification(
      updatedAt: rating.updatedAt,
      createdAt: rating.createdAt,
      content: '${rating.ratedBy} te avaliou com nota ${rating.ratingValue}',
      relatedId: rating.ratedBy!,
      notificationType: AppNotificationType.newFollower,
    );

    notifications.add(notification);
    notifications.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifications.toSet().toList();
  }

  void createMentionNotification(Message message) {
    final notification = AppNotification(
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      content:
          '@${message.sender?.nickname} ${message.private ? 'privadamente' : ''} te mencionou em uma mensagem: ${message.content}',
      relatedId: message.senderId,
      notificationType: AppNotificationType.mention,
    );

    notifications.add(notification);
    notifications.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifications.toSet().toList();
  }
}
