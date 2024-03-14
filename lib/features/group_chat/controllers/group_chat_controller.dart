import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/repositories/group_chat_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/user/repositories/user_repository.dart';
import 'package:splach/models/message.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/repositories/message_repository.dart';
import 'package:splach/services/image_service.dart';

class GroupChatController extends GetxController {
  GroupChatController(this.groupChat) {
    initializeCamera();
    debugPrint(
        'Chat Controller | Initializing the group chat for ${groupChat.id}');
    _messageRepository = MessageRepository(groupChat.id!);
  }

  final GroupChatRepository _chatRepository = Get.find();
  final UserRepository _userRepository = Get.find();
  final User user = Get.find();
  final _imageService = CameraService();

  late MessageRepository _messageRepository;
  final GroupChat groupChat;
  final participants = <User>[].obs;
  final messages = <Message>[].obs;
  final image = Rx<String?>(null);

  // final replyUser = Rx<User?>(null);

  final scrollController = ScrollController();
  final showButton = false.obs;
  final replyMessage = Rx<Message?>(null);

  final loading = false.obs;

  final cameraController = Rx<CameraController?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    loading.value = true;
    await _fetchChatUsers();
    _listenToChatParticipants();
    _listenToMessageStream();

    scrollController.addListener(scrollListener);
    loading.value = false;
  }

  Future<void> _fetchChatUsers() async {
    final chatUsers =
        await _userRepository.getUsersByIds(groupChat.participants);

    participants.assignAll(chatUsers);
    debugPrint(
        'Chat Group Controller | There is ${participants.length} in chat.');
  }

  Future<void> initializeCamera() async {
    await _imageService.initializeCamera();
    cameraController.value = _imageService.getController();
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

  Future<void> pickImage() async {
    final base64Image = await _imageService.takePhoto();

    if (base64Image != null) {
      image.value = base64Image;
    }

    // _imageService.dispose();
  }

  Future<void> pickImageFromGallery() async {
    final base64Image = await _imageService.pickImageFromGallery();

    if (base64Image != null) {
      image.value = base64Image;
    }
  }

  void toggleCamera() {
    if (cameraController.value!.value.isInitialized) {
      final direction = _getDirection();

      CameraDescription newCamera = _imageService.cameras.firstWhere(
        (camera) => camera.lensDirection == direction,
      );

      cameraController.value!.dispose();

      cameraController.value = CameraController(
        newCamera,
        ResolutionPreset.medium,
      );
      cameraController.value!.initialize();
    }
  }

  CameraLensDirection _getDirection() {
    return cameraController.value!.description.lensDirection ==
            CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
  }

  Future<SaveResult> sendMessage({String? content}) async {
    final newMessage = Message(
      content: content,
      image: image.value,
      senderId: user.id!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      replyId: replyMessage.value?.id,
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

  @override
  void onClose() {
    removeChatParticipant();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    _imageService.dispose();
    super.onClose();
  }
}
