import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/models/message.dart';
import 'package:splach/repositories/message_repository.dart';

class GroupChatController extends GetxController {
  GroupChatController(this.groupChat) {
    _messageRepository = Get.put(MessageRepository(groupChat.id!));
  }

  final GroupChatRepository _chatRepository = Get.find();
  final UserRepository _userRepository = Get.find();
  final User user = Get.find();

  late MessageRepository _messageRepository;
  final GroupChat groupChat;
  final users = <User>[].obs;
  final messages = <Message>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _fetchChatUsers();
    _listenToChatParticipants();
    _listenToReservationsStream();
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
    super.onClose();
  }

  void _listenToReservationsStream() {
    _messageRepository.streamLastMessages().listen((messageData) async {
      messages.assignAll(messageData);
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      messages.value = messages.map((message) {
        print('Found message sender? ${message.sender}');
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

  void sendMessage(String content) {
    final newMessage = Message(
      content: content,
      senderId: user.id!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _messageRepository.save(newMessage);
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
}
