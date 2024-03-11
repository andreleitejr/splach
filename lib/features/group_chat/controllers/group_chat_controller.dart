import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/models/message.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/repositories/message_repository.dart';

class GroupChatController extends GetxController {
  GroupChatController(this.groupChat) {
    debugPrint(
        'Chat Controller | Initializing the group chat for ${groupChat.id}');
    _messageRepository = MessageRepository(groupChat.id!);
  }

  final GroupChatRepository _chatRepository = Get.find();
  final UserRepository _userRepository = Get.find();
  final User user = Get.find();

  late MessageRepository _messageRepository;
  final GroupChat groupChat;
  final users = <User>[].obs;
  final messages = <Message>[].obs;
  final replyUser = Rx<User?>(null);

  final scrollController = ScrollController();
  final showButton = false.obs;
  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    await _fetchChatUsers();
    _listenToChatParticipants();
    _listenToReservationsStream();

    scrollController.addListener(scrollListener);

    print('################################### Loading Controller ${loading.value}');
    loading.value = false;
  }

  Future<void> _fetchChatUsers() async {
    final chatUsers =
        await _userRepository.getUsersByIds(groupChat.participants);

    users.assignAll(chatUsers);
    debugPrint('Chat Group Controller | There is ${users.length} in chat.');
  }

  @override
  void onClose() {
    removeChatParticipant();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _listenToReservationsStream() {
    _messageRepository.streamLastMessages().listen((messageData) async {
      messages.assignAll(messageData);
      messages.sort((b, a) => a.createdAt.compareTo(b.createdAt));

      messages.value = messages.map((message) {
        final sender =
            users.firstWhereOrNull((user) => user.id == message.senderId);

        message.sender = sender;

        return message;
      }).toList();
    });
  }

  void _listenToChatParticipants() {
    _chatRepository.stream(groupChat.id!).listen((chat) async {
      users.removeWhere((user) => !chat.participants.contains(user.id));

      debugPrint('User list after removal: ${users.map((user) => user.id)}');

      List<String> participantsNotInUserList = chat.participants
          .where(
              (participantId) => !users.any((user) => user.id == participantId))
          .toList();

      if (participantsNotInUserList.isNotEmpty) {
        debugPrint(
            'Searching for ${participantsNotInUserList.length} not found in local user list.');

        final newUsers =
            await _userRepository.getUsersByIds(participantsNotInUserList);

        users.addAll(newUsers);
      }
    });
  }

  Future<SaveResult> sendMessage(String content) async {
    final newMessage = Message(
      content: content,
      senderId: user.id!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      replyId: replyUser.value?.id,
    );

    return await _messageRepository.save(newMessage);
  }

  Future<void> removeChatParticipant() async {
    groupChat.participants
        .removeWhere((participant) => participant == user.id!);
    _chatRepository.update(groupChat);
    addSystemMessage();
  }

  Future<void> addSystemMessage() async {
    final message = Message(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      content: '${user.nickname} saiu da sala',
      senderId: user.id!,
      messageType: MessageType.system,
    );

    _messageRepository.save(message);
  }

  void scrollListener() {
    showButton.value = scrollController.position.pixels >= 500;
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
