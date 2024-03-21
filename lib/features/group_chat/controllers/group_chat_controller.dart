import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/models/participant.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/group_chat/repositories/participant_repository.dart';
import 'package:splach/features/refactor/controllers/report_controller.dart';
import 'package:splach/features/refactor/models/report.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/features/group_chat/models/message.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/features/group_chat/repositories/message_repository.dart';

class GroupChatController extends GetxController {
  GroupChatController(this.groupChat) {
    debugPrint(
        'Chat Controller | Initializing the group chat for ${groupChat.id}');
    _messageRepository = MessageRepository(groupChat.id!);
    _participantRepository = ParticipantRepository(groupChat.id!);
  }

  final GroupChatRepository _chatRepository = Get.find();
  final UserRepository _userRepository = Get.find();
  final User user = Get.find();

  late MessageRepository _messageRepository;
  late ParticipantRepository _participantRepository;
  final GroupChat groupChat;
  final participants = <Participant>[].obs;
  final messages = <Message>[].obs;
  final image = Rx<String?>(null);
  final private = false.obs;
  final recipients = <String>[].obs;
  final isCameraOpen = false.obs;

  // final replyUser = Rx<User?>(null);

  final scrollController = ScrollController();
  final showButton = false.obs;
  final replyMessage = Rx<Message?>(null);
  final isShowingMentionList = false.obs;
  final loading = false.obs;

  void updateMentionListVisibility(String value) {
    isShowingMentionList.value = value.endsWith('@');
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    // await _fetchChatUsers();
    // _listenToChatParticipants();
    // await Future.delayed(const Duration(seconds: 4));
    _listenToParticipants();
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

  // Future<void> _fetchChatUsers() async {
  //   final chatUsers =
  //       await _userRepository.getUsersByIds(groupChat.participants);
  //
  //   participants.assignAll(chatUsers);
  //   debugPrint(
  //       'Chat Group Controller | There is ${participants.length} in chat.');
  // }

  void _listenToMessageStream() async {
    _messageRepository.streamLastMessages().listen((messageData) async {
      messages.assignAll(messageData);
      // _filterPrivateMessages();
      messages.sort((b, a) => a.createdAt.compareTo(b.createdAt));

      updateMessageSenders();
    });
  }

  void _listenToParticipants() async {
    _participantRepository.streamParticipants().listen((participantData) async {
      if (participants.isNotEmpty) {
        final newParticipants = participantData.where((participant) {
          return !participants.any((existingParticipant) =>
              existingParticipant.id == participant.id);
        }).toList();

        final leftParticipants = participants.where((participant) {
          return !participantData
              .any((leftParticipant) => leftParticipant.id == participant.id);
        }).toList();

        if (newParticipants.isNotEmpty) {
          addSystemMessage(newParticipants);
        }
        if (leftParticipants.isNotEmpty) {
          addSystemMessage(leftParticipants, isLeaving: true);
        }
      }
      participants.assignAll(participantData);
      // _filterPrivateMessages();
      messages.sort((b, a) => a.createdAt.compareTo(b.createdAt));

      // updateMessageSenders();
    });
  }

  void addSystemMessage(List<Participant> participants,
      {bool isLeaving = false}) {
    final nicknames = participants.map((participant) => participant.nickname);
    final systemMessage = Message(
      createdAt: DateTime.now(),
      // updatedAt: DateTime.now(),
      content:
          '${nicknames.toString()} ${isLeaving ? 'saiu' : 'entrou'} da sala',
      senderId: user.id!,
      messageType: MessageType.system,
    );

    messages.add(systemMessage);
  }

  void updateMessageSenders() {
    messages.value = messages.map((message) {
      Participant? sender = participants.firstWhereOrNull(
        (participant) => participant.id == message.senderId,
      );

      message.sender = sender;
      return message;
    }).toList();
  }

  // void _filterPrivateMessages() {
  //   messages.value = messages.where((message) {
  //     if (message.private && message.replyId != user.id) {
  //       return false;
  //     }
  //     return true;
  //   }).toList();
  // }

  Future<SaveResult?> sendMessage({String? content}) async {
    if (loading.isTrue || content == null || content.isEmpty) return null;

    loading.value = true;

    final newMessage = Message(
      content: content,
      image: image.value,
      senderId: user.id!,
      createdAt: DateTime.now(),
      // updatedAt: DateTime.now(),
      replyId: replyMessage.value?.id,
      private: private.value,
      recipients: recipients.isEmpty ? null : recipients,
    );

    final result = await _messageRepository.save(newMessage);

    loading.value = false;

    return result;
  }

  Future<void> removeChatParticipant() async {
    final participant = Participant(
      id: user.id,
      nickname: user.nickname,
      image: user.image,
      status: Status.offline,
      createdAt: DateTime.now(),
      // updatedAt: DateTime.now(),
    );

    _participantRepository.save(participant, docId: user.id);
    _chatRepository.updateLastActivity(groupChat.id!);
  }

  void reportMessage(
    String messageId,
    String reason,
    String? comments,
  ) {
    final report = ReportController(
      type: ReportType.message,
      reportedId: messageId,
      reason: reason,
      comments: comments,
    );

    report.save();
  }

  // Future<void> addSystemMessage() async {
  //   final message = Message(
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     content: '${user.nickname} saiu da sala',
  //     senderId: user.id!,
  //     messageType: MessageType.system,
  //   );
  //
  //   _messageRepository.save(message);
  // }

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

  // void scrollToMessageIndex() {
  //   scrollController.animateTo(
  //       scrollController.position.minScrollExtent +
  //           (mentionIndexes.last *
  //               scrollController.position.viewportDimension /
  //               25),
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.easeInOut);
  // }

  // RxList<int> get mentionIndexes {
  //   final list = <int>[];
  //   for (var i = 0; i < messages.length; i++) {
  //     final message = messages[i];
  //
  //     final userMentioned = message.content != null &&
  //         message.content!.contains('@${user.nickname.removeAllWhitespace}');
  //
  //     if (userMentioned) {}
  //     list.add(i);
  //   }
  //   return list.obs;
  // }

  @override
  void onClose() {
    removeChatParticipant();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}
