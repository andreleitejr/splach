import 'package:get/get.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/utils/extensions.dart';

class NotificationController extends GetxController {
  final User user = Get.find();

  final _ratingRepository = Get.put(RatingRepository());
  final _userRepository = Get.put(UserRepository());

  final notifications = <AppNotification>[].obs;
  final ratingUsers = <User>[].obs;
  final ratings = <Rating>[].obs;

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;

    _listenToRelationshipsStream();

    ever(ratings, (callback) async {
      if (ratings.isNotEmpty) {
        await _getRatingUsers();
      }
    });

    loading.value = false;
  }

  void _listenToRelationshipsStream() {
    _ratingRepository.streamAll(userId: user.id).listen((newRatings) async {
      final userRatings = newRatings.where((rating) {
        return rating.type == RatingType.user;
      }).toList();

      ratings.assignAll(userRatings);
      ratings.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      if (ratings.isNotEmpty) {
        ratings.first.user = ratingUsers.firstWhereOrNull(
          (user) => user.id == ratings.first.userId,
        );

        ratings.first.user ??=
            await _userRepository.get(ratings.first.userId!);
        _createRatingNotification(ratings.first);
      }
    });
  }

  Future<void> _getRatingUsers() async {
    final ratingUserIds = ratings.map((rating) => rating.userId!).toList();

    ratingUsers.value = await _userRepository.getUsersByIds(ratingUserIds);
  }

  void _createRatingNotification(Rating rating) async {
    final nickname = rating.user?.nickname.toNickname();
    final starsText = rating.score > 1 ? 'stars' : 'star';
    final notification = AppNotification(
      id: rating.id!,
      updatedAt: rating.updatedAt,
      createdAt: rating.createdAt,
      content: '$nickname rated you with ${rating.score} $starsText',
      relatedId: rating.userId!,
      notificationType: AppNotificationType.rating,
      image: rating.user?.image,
    );

    _addNotification(notification);
  }

  void createMentionNotification(Message message) {
    final nickname = message.sender?.nickname.toNickname() ?? 'Somebody';
    final privateText = message.private ? 'privately' : '';
    final notification = AppNotification(
      id: message.id!,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      content: '$nickname $privateText mentioned you: ${message.content}',
      relatedId: message.senderId,
      notificationType: AppNotificationType.mention,
      image: message.sender?.image,
    );

    final hasNotification = notifications.any(
      (n) => n.id == notification.id,
    );
    if (!hasNotification) {
      _addNotification(notification);
    }
  }

  void _addNotification(AppNotification notification) {
    notifications.add(notification);
    notifications.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifications.toSet().toList();
  }
}
