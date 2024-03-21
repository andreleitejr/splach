import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/models/participant.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/group_chat/repositories/participant_repository.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/features/relationship/repositories/relationship_repository.dart';
import 'package:splach/features/services/location_service.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/chat_category.dart';
import 'package:splach/utils/extensions.dart';

class HomeController extends GetxController {
  final _user = Get.find<User>();
  final _chatRepository = Get.put(GroupChatRepository());
  final _relationshipRepository = Get.put(RelationshipRepository());
  final _locationService = Get.put(LocationService());

  final _groupChats = <GroupChat>[].obs;
  final filteredGroupChats = <GroupChat>[].obs;

  final _followers = <Relationship>[].obs;

  final _maxDistance = 1000;
  final _currentLocation = Rx<Position?>(null);

  final notifications = <AppNotification>[].obs;
  final category = Rx<ChatCategory>(categories.first);

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;

    await _getCurrentLocation();
    _getNearByChats();
    _listenToRelationshipsStream();
    _listenToCategories();

    loading.value = false;
  }

  Future<void> _getCurrentLocation() async {
    _currentLocation.value = await _locationService.getCurrentLocation();
  }

  void _listenToCategories() {
    ever(category, (_) {
      filteredGroupChats(filterChatsByCategory(_groupChats));
    });
  }

  void _getNearByChats() {
    _chatRepository.streamAll().listen((chats) {
      _updateChatsList(chats);
    });
    // _checkNewNearbyChat(chats);
  }

  // void _checkNewNearbyChat(List<GroupChat> chats) {
  //   for (final chat in chats) {
  //     if (chat.distance! < 500) {
  //       _createNearbyChatNotification(chat);
  //     }
  //   }
  // }

  // void _createNearbyChatNotification(GroupChat chat) {
  //   final notification = AppNotification(
  //     createdAt: chat.createdAt,
  //     content: 'Um novo chat foi criado próximo de você',
  //     relatedId: chat.id!,
  //     notificationType: AppNotificationType.newChat,
  //   );
  //
  //   notifications.add(notification);
  // }

  void _listenToRelationshipsStream() {
    _relationshipRepository.streamAll().listen((relationships) {
      final newFollowers = relationships.where((relationship) {
        return relationship.follower != _user.id && !relationship.isMutual;
      }).toList();

      for (final follower in newFollowers) {
        _createFollowNotification(follower);
      }

      _followers.value = relationships
          .where((relationship) =>
              relationship.follower != _user.id || relationship.isMutual)
          .toList();
    });
  }

  void _createFollowNotification(Relationship follower) {
    final notification = AppNotification(
      createdAt: follower.createdAt,
      content: '${follower.follower} começou a te seguir',
      relatedId: follower.userIds.firstWhere((id) => id != _user.id),
      notificationType: AppNotificationType.newFollower,
    );

    notifications.add(notification);
  }

  Future<void> _updateChatsList(List<GroupChat> chats) async {
    for (final chat in chats) {
      chat.distance = _locationService.calculateDistanceInMeters(
        _currentLocation.value!,
        chat.location.toPosition(),
      );
    }

    final nearByChats =
        chats.where((chat) => chat.distance! < _maxDistance).toList();

    nearByChats.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );

    _groupChats.assignAll(nearByChats);
    filteredGroupChats.value = _groupChats;
  }

  // Future<void> _getChatUsers(List<GroupChat> chats) async {
  //   // for (final chat in chats) {
  //   //   // debugPrint(
  //   //   //     'Home Controller | There is ${chat.participants.length} in chat');
  //   //   if (chat.participants.isNotEmpty) {
  //   //     // debugPrint('Home Controller | Getting users for chat id: ${chat.id}');
  //   //     chat.users = await _userRepository.getUsersByIds(chat.participants);
  //   //   }
  //   //   // debugPrint('Home Controller | Total users for chat id ${chat.id}: ${chat.users.length}');
  //   // }
  // }

  List<GroupChat> filterChatsByCategory(List<GroupChat> chats) {
    if (category.value.category == ChatCategory.all) {
      return chats;
    } else {
      return chats
          .where((chat) => chat.category == category.value.category)
          .toList();
    }
  }

  // Future<void> addChatParticipant(GroupChat chat) async {
  //   // if (!chat.participants.contains(_user.id)) {
  //   //   chat.participants.add(_user.id!);
  //   //   _chatRepository.update(chat);
  //   // }
  //   // _addSystemMessage(chat);
  // }

  Future<void> addParticipantToChat(GroupChat chat) async {
    final _participantRepository = Get.put(ParticipantRepository(chat.id!));

    final createdAt = chat.participants
        .firstWhereOrNull(
          (participant) => participant.id == _user.id,
        )
        ?.createdAt;

    final participant = Participant(
      id: _user.id,
      nickname: _user.nickname,
      image: _user.image,
      status: Status.online,
      createdAt: createdAt ?? DateTime.now(),
      // updatedAt: DateTime.now(),
    );

    _participantRepository.save(participant, docId: _user.id);
    _chatRepository.updateLastActivity(chat.id!);
  }

// Future<void> _addSystemMessage(GroupChat chat) async {
//   final messageRepository = Get.put(MessageRepository(chat.id!));
//
//   final message = Message(
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     content: '${_user.nickname} entrou na sala',
//     senderId: _user.id!,
//     messageType: MessageType.system,
//   );
//
//   messageRepository.save(message);
// }
}
