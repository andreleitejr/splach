import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/services/location_service.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/message.dart';
import 'package:splach/repositories/message_repository.dart';
import 'package:splach/utils/extensions.dart';

class HomeController extends GetxController {
  final User user = Get.find();
  final _chatRepository = Get.put(GroupChatRepository());
  final _locationService = Get.put(LocationService());

  final groupChats = <GroupChat>[].obs;
  final currentLocation = Rx<Position?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    currentLocation.value = await _locationService.getCurrentLocation();
    _listenToReservationsStream();
  }

  void _listenToReservationsStream() {
    _chatRepository.streamAll().listen((chats) {
      // groupChats.clear();

      for (final chat in chats) {
        chat.distance = _locationService.calculateDistanceInMeters(
          currentLocation.value!,
          chat.location.toPosition(),
        );
      }

      final nearByChats =
          chats.where((chat) => chat.distance! < 41000).toList();

      nearByChats.sort((a, b) => a.distance!.compareTo(b.distance!));

      groupChats.assignAll(nearByChats);
    });
  }

  Future<void> addChatParticipant(GroupChat chat) async {
    chat.participants.add(user.id!);
    _chatRepository.update(chat);
    addSystemMessage(chat);
  }

  /// Melhorar essa funcao
  Future<void> addSystemMessage(GroupChat chat) async {
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
