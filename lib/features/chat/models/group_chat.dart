import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/utils/extensions.dart';

import 'chat.dart';

enum GroupType {
  public,
  private,
}

class GroupChat extends Chat {
  final GeoPoint location;
  final String title;
  final String description;
  final GroupType groupType;
  final String category;
  final DateTime lastActivity;

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
    required this.category,
    required this.lastActivity,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          // participants: participants,
          participantsLimit: participantsLimit,
          messages: messages,
          images: images,
        );

  GroupChat.fromDocument(DocumentSnapshot document)
      : location = document.get('location'),
        title = document.get('title'),
        description = document.get('description'),
        groupType = GroupTypeExtension.fromString(
          document.get('groupType'),
        ),
        category = document.get('category'),
        lastActivity = (document.get('lastActivity') as Timestamp).toDate(),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'title': title,
      'description': description,
      'groupType': groupType.toStringSimplified(),
      'category': category,
      'lastActivity': lastActivity,
      ...super.toMap(),
    };
  }
}