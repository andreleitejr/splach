import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/chat.dart';
import 'package:splach/models/message.dart';

enum GroupType {
  public,
  private,
  restricted,
}

class GroupChat extends Chat {
  final GeoPoint location;
  final String title;
  final String description;
  final GroupType groupType;

  double? distance;

  GroupChat({
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> participants,
    required int participantsLimit,
    required List<Message> messages,
    required List<String> images,
    required this.location,
    required this.title,
    required this.description,
    required this.groupType,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          participants: participants,
          participantsLimit: participantsLimit,
          messages: messages,
          images: images,
        );

  GroupChat.fromDocument(DocumentSnapshot document)
      : location = document['location'],
        title = document['title'],
        description = document['description'],
        groupType = GroupType.values[document['groupType']],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'title': title,
      'description': description,
      'groupType': groupType.index,
      ...super.toMap(),
    };
  }
}
