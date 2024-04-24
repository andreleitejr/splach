import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum RatingType { user, chat }

class Rating extends BaseModel {
  final String userId;
  final String userNickname;
  final String ratedId;
  double score;
  final RatingType type;

  User? user;

  Rating({
    required super.createdAt,
    required super.updatedAt,
    required this.userId,
    required this.userNickname,
    required this.ratedId,
    required this.score,
    this.type = RatingType.user,
  });

  Rating.fromDocument(DocumentSnapshot document)
      : userId = document.get('userId'),
        userNickname = document.get('userNickname'),
        ratedId = document.get('ratedId'),
        score = double.parse(document.get('ratingValue').toString()),
        type = RatingTypeExtension.fromString(document.get('type')),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': Get.find<User>().id,
      'userNickname': Get.find<User>().nickname,
      'ratedId': ratedId,
      'ratingValue': score,
      'type': type.toStringSimplified(),
      ...super.toMap(),
    };
  }
}
