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
  final participants = <User>[].obs;
  final messages = <Message>[].obs;
  final image = Rx<String?>(null);
  final isCameraOpen = false.obs;

  // final replyUser = Rx<User?>(null);

  final scrollController = ScrollController();
  final showButton = false.obs;
  final replyMessage = Rx<Message?>(null);
  final isShowingMentionList = false.obs;

  void updateMentionListVisibility(String value) {
    isShowingMentionList.value = value.endsWith('@');
    update();
  }

  RxList<int> get mentionIndexes {
    final list = <int>[];
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];

      final userMentioned = message.content != null &&
          message.content!.contains('@${user.nickname.removeAllWhitespace}');

      print(
          ' ################## hudhuasdhauhasuhasduhsdauashdudashu ${message.content} @${user.nickname} ${message.content!.contains('@${user.nickname}')}');
      if (userMentioned) {
        print(
            'HAHAHAHAHAH  ################## hudhuasdhauhasuhasduhsdauashdudashu ${message.content}');
      }
      list.add(i);
    }
    return list.obs;
  }

  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    await _fetchChatUsers();
    _listenToChatParticipants();
    _listenToMessageStream();
    scrollController.addListener(scrollListener);

    // cameraController.value = CameraController(
    //   // Get a specific camera from the list of available cameras.
    //   cameras.first,
    //   // Define the resolution to use.
    //   ResolutionPreset.medium,
    // );
    loading.value = false;
  }

  Future<void> _fetchChatUsers() async {
    final chatUsers =
        await _userRepository.getUsersByIds(groupChat.participants);

    participants.assignAll(chatUsers);
    debugPrint(
        'Chat Group Controller | There is ${participants.length} in chat.');
  }

  void _listenToMessageStream() async {
    _messageRepository.streamLastMessages().listen((messageData) async {
      messages.assignAll(messageData);
      messages.sort((b, a) => a.createdAt.compareTo(b.createdAt));

      updateMessageSenders();
    });
  }

  void _listenToChatParticipants() {
    _chatRepository.stream(groupChat.id!).listen(
      (chat) async {
        participants.removeWhere(
          (user) => !chat.participants.contains(user.id),
        );

        debugPrint(
            'User list after removal: ${participants.map((user) => user.id)}');

        List<String> participantsNotInUserList = chat.participants
            .where((participantId) =>
                !participants.any((user) => user.id == participantId))
            .toList();

        if (participantsNotInUserList.isNotEmpty) {
          debugPrint(
              'Searching for ${participantsNotInUserList.length} not found in local user list.');

          final newUsers = await _userRepository.getUsersByIds(
            participantsNotInUserList,
          );

          participants.addAll(newUsers);
          updateMessageSenders();
        }
      },
    );
  }

  void updateMessageSenders() {
    messages.value = messages.map((message) {
      User? sender = participants.firstWhereOrNull(
        (user) => user.id == message.senderId,
      );

      message.sender = sender;
      return message;
    }).toList();
  }

  Future<SaveResult?> sendMessage({String? content}) async {
    if (loading.isTrue || content == null || content.isEmpty) return null;

    loading.value = true;

    final newMessage = Message(
      content: content,
      image: image.value,
      senderId: user.id!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      replyId: replyMessage.value?.id,
    );

    final result = await _messageRepository.save(newMessage);

    loading.value = false;

    return result;
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

  void scrollToMessageIndex() {
    scrollController.animateTo(
        scrollController.position.minScrollExtent +
            (mentionIndexes.last *
                scrollController.position.viewportDimension /
                25),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut);
  }

  @override
  void onClose() {
    removeChatParticipant();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}
