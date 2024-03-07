import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/models/message.dart';

class Chat extends BaseModel {
  final List<String> participants;
  final int participantsLimit;
  final List<Message> messages;
  final List<String> images;

  List<User> users = [];

  Chat({
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.participants,
    required this.participantsLimit,
    required this.messages,
    required this.images,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  Chat.fromDocument(DocumentSnapshot document)
      : participants = List<String>.from(document['participants']),
        participantsLimit = document['participantsLimit'],
        messages = (document['messages'] as List)
            .map((message) => Message.fromDocument(message))
            .toList(),
        images = List<String>.from(document['images']),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'participantsLimit': participantsLimit,
      'messages': messages.map((message) => message.toMap()).toList(),
      'images': images,
      ...super.toMap(),
    };
  }
}
