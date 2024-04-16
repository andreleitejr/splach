import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/components/chat_input.dart';
import 'package:splach/features/chat/models/group_chat.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/chat/repositories/chat_repository.dart';
import 'package:splach/features/chat/repositories/message_storage_repository.dart';
import 'package:splach/features/chat/repositories/participant_repository.dart';
import 'package:splach/features/notification/controllers/notification_controller.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/rating/repositories/rating_repository.dart';
import 'package:splach/features/report/controllers/report_controller.dart';
import 'package:splach/features/report/models/report.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/features/chat/repositories/message_repository.dart';
import 'package:splach/utils/extensions.dart';

class ChatController extends GetxController {
  ChatController(this.chat) {
    debugPrint('Chat Controller | Initializing the group chat for ${chat.id}');
    _messageRepository = MessageRepository(chat.id!);
    _participantRepository = ParticipantRepository(chat.id!);
  }

  final GroupChat chat;

  final ChatRepository _chatRepository = Get.find();
  final _messageStorageRepository = Get.put(MessageStorageRepository());
  final NotificationController notificationController = Get.find();
  final _repository = Get.put(RatingRepository());
  final User user = Get.find();
  final messageController = MentionHighlightingController();

  late MessageRepository _messageRepository;
  late ParticipantRepository _participantRepository;
  final _userRepository = Get.put(UserRepository());

  final participants = <Participant>[].obs;
  final messages = <Message>[].obs;
  final image = Rx<File?>(null);
  String? imageUrl;
  final private = false.obs;
  final recipients = <String>[].obs;
  final isCameraOpen = false.obs;
  final isTyping = false.obs;

  // final replyUser = Rx<User?>(null);

  final scrollController = ScrollController();
  final showButton = false.obs;
  final replyMessage = Rx<Message?>(null);

  final userRatings = <Rating>[].obs;
  final rating = Rx<Rating?>(null);
  final score = 0.obs;

  final isShowingMentionList = false.obs;
  final mentions = <String>[];
  final loading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    _listenToParticipants();
    _listenToMessageStream();
    scrollController.addListener(scrollListener);

    await _fetchUserRatings();
    loading.value = false;
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
      messages.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    });
  }

  void _listenToMessageStream() async {
    _messageRepository.streamLastMessages().listen((messageData) async {
      messages.assignAll(messageData);
      // _filterPrivateMessages();
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      updateMessageSenders();

      if (messages.isNotEmpty) {
        // messages.first.sender = participants.firstWhereOrNull(
        //   (participant) => participant.id == messages.first.senderId,
        // );

        messages.first.sender ??=
            await _participantRepository.get(messages.first.senderId);
        _verifyMessageAndCreateMentionNotification(messages.first);
      }
    });
  }

  void _verifyMessageAndCreateMentionNotification(Message message) {
    if (message.recipients != null && message.recipients!.contains(user.id)) {
      notificationController.createMentionNotification(message);
    }
  }

  void updateMentionListVisibility(String value) {
    isShowingMentionList.value = value.endsWith('@');
    update();
  }

  void updateIfIsMentioning(String value) {
    final nicknames = participants
        .map((participant) => participant.nickname.toNickname())
        .toList();

    mentions.clear();

    for (final nickname in nicknames) {
      if (value.contains(nickname)) {
        mentions.add(nickname);
      } else {
        mentions.remove(nickname);
      }
    }

    debugPrint('Updating mention list | Mention list is not empty $mentions');

    debugPrint('Updating mention list |Participants ${participants.length}');

    final mentionedParticipants = participants.where(
      (participant) => mentions.contains(
        participant.nickname.toNickname(),
      ),
    );

    debugPrint(
        'Updating mention list | Mentioned Participants ${mentionedParticipants.length}');

    final mentionedParticipantsIds =
        mentionedParticipants.map((participant) => participant.id!).toList();

    if (replyMessage.value == null) {
      recipients.assignAll(mentionedParticipantsIds);
    } else {
      recipients.addAll(mentionedParticipantsIds);
    }

    recipients.value = recipients.toSet().toList();

    debugPrint('Updating recipient list | Recipients $recipients');

    update();
  }

  void addSystemMessage(List<Participant> participants,
      {bool isLeaving = false}) {
    final nickname =
        participants.map((participant) => participant.nickname).toList().first;

    final systemMessage = Message(
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      content:
          '${nickname.toNickname()} ${isLeaving ? 'saiu' : 'entrou'} da sala',
      senderId: user.id!,
      messageType: MessageType.system,
    );

    messages.add(systemMessage);
  }

  // void _filterPrivateMessages() {
  //   messages.value = messages.where((message) {
  //     if (message.private && message.replyId != user.id) {
  //       return false;
  //     }
  //     return true;
  //   }).toList();
  // }

  void sendTemporaryMessage({String? content}) {
    final temporaryMessageList = <Message>[];
    temporaryMessageList.assignAll(messages);
    final temporaryMessage = _createMessage(content, '');
    temporaryMessageList.add(temporaryMessage);

    messages.assignAll(temporaryMessageList);

    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    updateMessageSenders();
  }

  Future<SaveResult?> sendMessage({String? content}) async {
    if (_shouldNotSendMessage(content)) {
      return null;
    }

    loading.value = true;
    final imageUrl = await _uploadImageIfRequired();

    final newMessage = _createMessage(content, imageUrl);

    newMessage.temporaryImage = null;

    _updateMessageList(newMessage);

    final result = await _saveMessage(newMessage);

    if (result == SaveResult.success) {
      newMessage.status = MessageStatus.sent;
    } else {
      newMessage.status = MessageStatus.error;
    }

    _updateMessageList(newMessage);

    loading.value = false;

    return result;
  }

  Future<SaveResult?> retryMessage(Message message) async {
    if (loading.isTrue) {
      return null;
    }

    loading.value = true;

    // final imageUrl = await _uploadImageIfRequired();
    //
    // final newMessage = _createMessage(content, imageUrl);

    // newMessage.temporaryImage = null;

    // _updateMessageList(message);

    final result = await _saveMessage(message);

    if (result == SaveResult.success) {
      message.status = MessageStatus.sent;
    }

    _updateMessageList(message);

    loading.value = false;

    return result;
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

  void _updateMessageList(Message newMessage) {
    final index = messages.indexWhere(
      (message) => message.id == newMessage.id,
    );

    if (index != -1) {
      messages.replaceRange(index, index + 1, [newMessage]);
    }
  }

  bool _shouldNotSendMessage(String? content) {
    return loading.isTrue ||
        (content == null || content.isEmpty) && image.value == null;
  }

  Future<String?> _uploadImageIfRequired() async {
    if (image.value == null) return null;
    return await _messageStorageRepository.upload(image.value!);
  }

  Message _createMessage(String? content, String? imageUrl) {
    return Message(
      content: content,
      imageUrl: imageUrl,
      senderId: user.id!,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      replyId: replyMessage.value?.id,
      private: private.value,
      recipients: recipients.isEmpty ? null : recipients,
      temporaryImage: image.value,
    );
  }

  Future<SaveResult?> _saveMessage(Message message) async {
    return await _messageRepository.save(message);
  }

  Future<void> removeChatParticipant() async {
    final participant = Participant(
      id: user.id,
      nickname: user.nickname,
      image: user.image!,
      status: Status.offline,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _participantRepository.save(participant, docId: user.id);
    _chatRepository.updateLastActivity(chat.id!);
  }

  Future<void> addParticipantToChat() async {
    final participant = Participant(
      id: user.id,
      nickname: user.nickname,
      image: user.image!,
      status: Status.online,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _participantRepository.update(participant);
    _chatRepository.updateLastActivity(chat.id!);
  }

  Future<void> _fetchUserRatings() async {
    userRatings.value =
        await _repository.getRating(Get.find<User>().id!, isUserRatings: true);
  }

  void checkRatingValue(String ratedId) {
    if (alreadyRated(ratedId)) {
      rating.value =
          userRatings.firstWhere((rating) => rating.ratedId == ratedId);

      score.value = rating.value!.score;
    }
  }

  bool alreadyRated(String ratedId) {
    return userRatings.any((rating) => rating.ratedId == ratedId);
  }

  Future<void> rate(String ratedId) async {
    if (alreadyRated(ratedId)) {
      rating.value!.score = score.value;
      await _repository.update(rating.value!);
    } else {
      final newRating = Rating(
        ratedId: ratedId,
        score: score.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.save(newRating);
    }
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
  //         message.content!.contains(user.nickname.toNickname());
  //
  //     if (userMentioned) {}
  //     list.add(i);
  //   }
  //   return list.obs;
  // }

  Future<User?> getUser(String userId) async {
    return await _userRepository.get(userId);
  }

  @override
  void onClose() {
    removeChatParticipant();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
