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

class Message extends BaseModel {
  final String? content;
  final String senderId;
  final String? replyId;
  final String? image;
  final MessageType messageType;
  final bool private;
  final List<String>? recipients;

  Participant? sender;
  Message? replyMessage;

  Message({
    required super.createdAt,
    required super.updatedAt,
    this.content,
    required this.senderId,
    this.replyId,
    this.image,
    this.messageType = MessageType.user,
    this.private = false,
    this.recipients,
  });

  Message.fromDocument(DocumentSnapshot document)
      : content = document.get('content'),
        senderId = document.get('senderId'),
        replyId = document.get('replyId'),
        image = document.get('image'),
        messageType = MessageTypeExtension.fromString(
          document.get('messageType')
        ),
        private = document.get('private'),
        recipients = List<String>.from(
          document.get('recipients') ?? [],
        ),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'replyId': replyId,
      'image': image,
      'messageType': messageType.toStringSimplified(),
      'private': private,
      'recipients': recipients,
      ...super.toMap(),
    };
  }

  bool get isFromSystem => messageType == MessageType.system;

  bool get isFromUser => senderId == Get.find<User>().id;
}
