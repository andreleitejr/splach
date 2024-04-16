import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/address/models/address.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/utils/extensions.dart';

import 'chat.dart';

enum GroupType {
  public,
  private,
}

class GroupChat extends Chat {
  final String title;
  final String description;
  final GeoPoint location;
  final Address address;
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
    required this.title,
    required this.description,
    required this.location,
    required this.address,
    required this.groupType,
    required this.category,
    required this.lastActivity,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          // participants: participants,
          participantsLimit: participantsLimit,
          // messages: messages,
          images: images,
        );

  GroupChat.fromDocument(DocumentSnapshot document)
      : title = document.get('title'),
        description = document.get('description'),
        location = document.get('location'),
        address = Address.fromMap(document.get('address')),
        groupType = GroupTypeExtension.fromString(
          document.get('groupType'),
        ),
        category = document.get('category'),
        lastActivity = (document.get('lastActivity') as Timestamp).toDate(),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'address': address.toMap(),
      'groupType': groupType.toStringSimplified(),
      'category': category,
      'lastActivity': lastActivity,
      ...super.toMap(),
    };
  }
}
