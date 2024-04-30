import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum MessageType {
  system,
  user,
}

enum MessageStatus {
  pending,
  sent,
  error,
}

class Message extends BaseModel {
  final String? content;
  final String senderId;
  final String? replyId;
  final String? imageUrl;
  final MessageType messageType;
  final bool private;
  final List<String>? recipients;

  late MessageStatus status;
  File? temporaryImage;

  Participant? sender;
  Message? replyMessage;

  Message({
    required super.createdAt,
    required super.updatedAt,
    this.content,
    required this.senderId,
    this.replyId,
    this.imageUrl,
    this.messageType = MessageType.user,
    this.private = false,
    this.recipients,
    this.temporaryImage,
    this.status = MessageStatus.pending,
  });

  Message.fromDocument(DocumentSnapshot document)
      : content = document.get('content'),
        senderId = document.get('senderId'),
        replyId = document.get('replyId'),
        imageUrl = document.get('imageUrl'),
        messageType =
            MessageTypeExtension.fromString(document.get('messageType')),
        private = document.get('private'),
        recipients = List<String>.from(
          document.get('recipients') ?? [],
        ),
        status = MessageStatus.sent,
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'replyId': replyId,
      'imageUrl': imageUrl,
      'messageType': messageType.toStringSimplified(),
      'private': private,
      'recipients': recipients,
      ...super.toMap(),
    };
  }

  bool get isFromSystem => messageType == MessageType.system;

  bool get isFromUser => senderId == Get.find<User>().id;

  bool get isPrivate => private/* && replyId == Get.find<User>().id*/;

  bool get isReplied => recipients!.contains(Get.find<User>().id);

  bool get isHighlighted => isReplied && isPrivate;
}
