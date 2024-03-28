import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum RatingType { user, chat }

class Rating extends BaseModel {
  final String? ratedBy;
  final String ratedId;
  int ratingValue;
  final RatingType type;

  Rating({
    required super.createdAt,
    required super.updatedAt,
    this.ratedBy,
    required this.ratedId,
    required this.ratingValue,
    this.type = RatingType.user,
  });

  Rating.fromDocument(DocumentSnapshot document)
      : ratedBy = document.get('ratedBy'),
        ratedId = document.get('ratedId'),
        ratingValue = document.get('ratingValue'),
        type = RatingTypeExtension.fromString(document.get('type')),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'ratedBy': Get.find<User>().id,
      'ratedId': ratedId,
      'ratingValue': ratingValue,
      'type': type.toStringSimplified(),
      ...super.toMap(),
    };
  }
}
