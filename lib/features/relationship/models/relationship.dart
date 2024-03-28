import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/models/base_model.dart';

class Relationship extends BaseModel {
  final List<String> userIds;
  String follower;

  Relationship({
    required this.userIds,
    required this.follower,
    required super.createdAt,
    required super.updatedAt,
  });

  Relationship.fromDocument(DocumentSnapshot document)
      : userIds = List<String>.from(document['userIds']),
        follower = document['follower'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
      'follower': follower,
      ...super.toMap(),
    };
  }

  static const mutual = 'mutual';

  bool get isMutual => follower == Relationship.mutual;
}
