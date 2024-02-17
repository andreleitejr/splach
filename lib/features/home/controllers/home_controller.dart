// import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/features/relationship/repositories/relationship_repository.dart';
import 'package:splach/features/services/location_service.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/chat_category.dart';
import 'package:splach/models/message.dart';
import 'package:splach/repositories/message_repository.dart';
import 'package:splach/utils/extensions.dart';

class HomeController extends GetxController {
  final User user = Get.find();
  final _chatRepository = Get.put(GroupChatRepository());
  final _relationshipRepository = Get.put(RelationshipRepository());
  final _locationService = Get.put(LocationService());

  final _maxDistance = 41000;

  final notifications = <AppNotification>[].obs;
  final groupChats = <GroupChat>[].obs;
  final filteredGroupChats = <GroupChat>[].obs;
  final followers = <Relationship>[].obs;
  final currentLocation = Rx<Position?>(null);

  final category = Rx<ChatCategory>(
      categories.firstWhere((t) => t.category == ChatCategory.all));

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;

    currentLocation.value = await _locationService.getCurrentLocation();

    _listenToChatsStream();

    _listenToRelationshipsStream();

    ever(category, (_) {
      filteredGroupChats(filterChatsByCategory(groupChats));
    });

    loading.value = false;
  }

  void _listenToChatsStream() {
    _chatRepository.streamAll().listen((chats) {
      _updateChatsList(chats);
      _checkNewNearbyChat(chats);
    });
  }

  void _listenToRelationshipsStream() {
    _relationshipRepository.streamAll().listen((relationships) {
      final newFollowers = relationships.where((relationship) {
        return relationship.follower != user.id && !relationship.isMutual;
      }).toList();

      for (final follower in newFollowers) {
        _createFollowNotification(follower);
      }

      followers.value = relationships
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

  void _checkNewNearbyChat(List<GroupChat> chats) {
    final newNearbyChats = chats.where((chat) {
      return chat.distance! < _maxDistance &&
          !groupChats.any((existingChat) => existingChat.id == chat.id);
    }).toList();

    for (final chat in newNearbyChats) {
      _createNearbyChatNotification(chat);
    }
  }

  void _createNearbyChatNotification(GroupChat chat) {
    final notification = AppNotification(
      createdAt: chat.createdAt,
      content: 'Um novo chat foi criado próximo de você',
      relatedId: chat.id!,
      notificationType: AppNotificationType.newChat,
    );

    notifications.add(notification);
  }

  void _updateChatsList(List<GroupChat> chats) {
    for (final chat in chats) {
      chat.distance = _locationService.calculateDistanceInMeters(
        currentLocation.value!,
        chat.location.toPosition(),
      );
    }

    final nearByChats =
        chats.where((chat) => chat.distance! < _maxDistance).toList();
    nearByChats.sort((a, b) => a.distance!.compareTo(b.distance!));

    groupChats.assignAll(nearByChats);
    filteredGroupChats.value = groupChats;
  }

  List<GroupChat> filterChatsByCategory(List<GroupChat> chats) {
    if (category.value.category == ChatCategory.all) {
      return chats;
    } else {
      return chats
          .where((chat) => chat.category == category.value.category)
          .toList();
    }
  }

  Future<void> addChatParticipant(GroupChat chat) async {
    chat.participants.add(user.id!);
    _chatRepository.update(chat);
    _addSystemMessage(chat);
  }

  Future<void> _addSystemMessage(GroupChat chat) async {
    final messageRepository = Get.put(MessageRepository(chat.id!));

    final message = Message(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      content: '${user.nickname} entrou na sala',
      senderId: user.id!,
      messageType: MessageType.system,
    );

    messageRepository.save(message);
  }
}
