import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/chat/models/message.dart';

class Chat extends BaseModel {
  // final List<String> participants;
  final int participantsLimit;
  List<Message> messages;
  final List<String> images;

  // List<User> users = [];
  var participants = <Participant>[];

  Chat({
    required super.createdAt,
    required super.updatedAt,
    // required this.participants,
    required this.participantsLimit,
    required this.messages,
    required this.images,
  });

  Chat.fromDocument(DocumentSnapshot document)
      :
        // participants = List<String>.from(document.get('participants')),
        participantsLimit = document.get('participantsLimit'),
        messages = (document.get('messages') as List)
            .map((message) => Message.fromDocument(message))
            .toList(),
        images = List<String>.from(document.get('images')),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      // 'participants': participants,
      'participantsLimit': participantsLimit,
      'messages': messages.map((message) => message.toMap()).toList(),
      'images': images,
      ...super.toMap(),
    };
  }
}
