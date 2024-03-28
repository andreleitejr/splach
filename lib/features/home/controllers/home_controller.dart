import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/models/group_chat.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/chat/repositories/chat_repository.dart';
import 'package:splach/features/chat/repositories/participant_repository.dart';
import 'package:splach/features/services/location_service.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/chat/models/chat_category.dart';
import 'package:splach/services/push_notification_service.dart';
import 'package:splach/utils/extensions.dart';

class HomeController extends GetxController {
  final _user = Get.find<User>();
  final _chatRepository = Get.put(ChatRepository());
  final _locationService = Get.put(LocationService());
  final _pushNotificationService = Get.put(PushNotificationService());

  final _groupChats = <GroupChat>[].obs;
  final filteredGroupChats = <GroupChat>[].obs;

  final _maxDistance = 1000000;
  final _currentLocation = Rx<Position?>(null);

  final category = Rx<ChatCategory>(categories.first);

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loading.value = true;

    await _getCurrentLocation();

    _getNearByChats();
    _listenToCategories();
    _initPushNotifications();

    loading.value = false;
  }

  Future<void> _getCurrentLocation() async {
    _currentLocation.value = await _locationService.getCurrentLocation();
  }

  void _getNearByChats() {
    _chatRepository.streamAll().listen((chats) {
      _updateChats(chats);
    });
  }

  void _listenToCategories() {
    ever(category, (_) {
      filteredGroupChats(filterChatsByCategory(_groupChats));
    });
  }

  void _initPushNotifications() {
    _pushNotificationService.requestPermission();
    _pushNotificationService.loadFCM();
    _pushNotificationService.listenFCM();
  }

  Future<void> _updateChats(List<GroupChat> chats) async {
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

  List<GroupChat> filterChatsByCategory(List<GroupChat> chats) {
    if (category.value.category == ChatCategory.all) {
      return chats;
    } else {
      return chats
          .where((chat) => chat.category == category.value.category)
          .toList();
    }
  }

  Future<void> addParticipantToChat(GroupChat chat) async {
    final participantRepository = Get.put(ParticipantRepository(chat.id!));

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
      updatedAt: DateTime.now(),
    );

    participantRepository.save(participant, docId: _user.id);
    _chatRepository.updateLastActivity(chat.id!);
  }
}
