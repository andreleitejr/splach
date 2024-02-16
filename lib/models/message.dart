import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum MessageType { system, user }

class Message extends BaseModel {
  final String content;
  final String senderId;
  final MessageType messageType;

  User? sender;

  Message({
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.content,
    required this.senderId,
    this.messageType = MessageType.user,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  Message.fromDocument(DocumentSnapshot document)
      : content = document['content'],
        senderId = document['senderId'],
        messageType = MessageTypeExtension.fromString(document['messageType']),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'messageType': messageType.toStringSimplified(),
      ...super.toMap(),
    };
  }

  bool get isFromSystem => messageType == MessageType.system;
}
