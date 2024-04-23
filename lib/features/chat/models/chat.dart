import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/models/base_model.dart';

class Chat extends BaseModel {
  final int participantsLimit;
  final List<String> images;

  var participants = <Participant>[];
  var messages = <Message>[];

  Chat({
    required super.createdAt,
    required super.updatedAt,
    required this.participantsLimit,
    // required this.messages,
    required this.images,
  });

  Chat.fromDocument(DocumentSnapshot document)
      : participantsLimit = document.get('participantsLimit'),
        // messages = (document.get('messages') as List)
        //     .map((message) => Message.fromDocument(message))
        //     .toList(),
        images = List<String>.from(document.get('images')),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'participantsLimit': participantsLimit,
      // 'messages': messages.map((message) => message.toMap()).toList(),
      'images': images,
      ...super.toMap(),
    };
  }
}
