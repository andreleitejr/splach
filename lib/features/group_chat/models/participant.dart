import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum Status {
  online,
  offline,
}

class Participant extends BaseModel {
  final String nickname;
  final String image;
  final Status status;

  Participant({
    required super.id,
    required this.nickname,
    required this.image,
    required this.status,
    required super.createdAt,
    required super.updatedAt,
  });

  Participant.fromDocument(DocumentSnapshot document)
      : nickname = document.get('nickname'),
        image = document.get('image'),
        status = StatusExtension.fromString(document.get('status')),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'image': image,
      'status': status.toStringSimplified(),
      ...super.toMap(),
    };
  }
}
