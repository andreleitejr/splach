
import 'package:get/get.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/features/relationship/repositories/relationship_repository.dart';
import 'package:splach/features/user/models/user.dart';

class NotificationController extends GetxController {
  final User user = Get.find();

  final _relationshipRepository = Get.put(RelationshipRepository());

  final notifications = <AppNotification>[].obs;

  final _followers = <Relationship>[].obs;

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;

    _listenToRelationshipsStream();

    loading.value = false;
  }

  void _listenToRelationshipsStream() {
    _relationshipRepository.streamAll().listen((relationships) {
      final newFollowers = relationships.where((relationship) {
        return relationship.follower != user.id && !relationship.isMutual;
      }).toList();

      for (final follower in newFollowers) {
        _createFollowNotification(follower);
      }

      _followers.value = relationships
          .where((relationship) =>
      relationship.follower != user.id || relationship.isMutual)
          .toList();
    });
  }

  void _createFollowNotification(Relationship follower) {
    final notification = AppNotification(
      createdAt: follower.createdAt,
      content: '${follower.follower} começou a te seguir',
      relatedId: follower.userIds.firstWhere((id) => id != user.id),
      notificationType: AppNotificationType.newFollower,
    );

    notifications.add(notification);
  }
}