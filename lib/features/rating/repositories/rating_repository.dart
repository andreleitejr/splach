import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/firestore_repository.dart';

class RatingRepository extends FirestoreRepository<Rating> {
  RatingRepository()
      : super(
          collectionName: 'ratings',
          fromDocument: (document) => Rating.fromDocument(document),
        );

  @override
  Stream<List<Rating>> streamAll({String? userId}) {
    try {
      Query query = firestore.collection(collectionName);

      if (userId != null) {
        query = query.where('ratedId', isEqualTo: userId);
      }

      final stream = query.snapshots().map(
        (querySnapshot) {
          final dataList =
              querySnapshot.docs.map((doc) => fromDocument(doc)).toList();
          return dataList;
        },
      );

      return stream;
    } catch (error) {
      debugPrint(
          'Error streaming data from $collectionName in Firestore: $error');
      return Stream.value([]);
    }
  }

  Future<List<Rating>> getRating(String userId,
      {bool isUserRatings = false}) async {
    try {
      final query = firestore.collection(collectionName).where(
            isUserRatings ? 'userId' : 'ratedId',
            isEqualTo: userId,
          );

      final querySnapshot = await query.get();

      final dataList =
          querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

      debugPrint(
          'Successful fetch ${dataList.length} documents for $collectionName in Firestore.');

      return dataList;
    } catch (error) {
      debugPrint(
          'Error fetching all data from $collectionName in Firestore: $error');
      return [];
    }
  }

  Future<Rating?> checkRatingExists(String ratedId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(collectionName)
          .where('userId', isEqualTo: Get.find<User>().id)
          .where('ratedId', isEqualTo: ratedId)
          .get();

      return fromDocument(querySnapshot.docs.last);
    } catch (e) {
      debugPrint('Erro ao verificar a existência de rating: $e');
      return null;
    }
  }
}
