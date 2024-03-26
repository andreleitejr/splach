import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/repositories/firestore_repository.dart';

class RatingRepository extends FirestoreRepository<Rating> {
  RatingRepository()
      : super(
          collectionName: 'ratings',
          fromDocument: (document) => Rating.fromDocument(document),
        );

  @override
  Future<List<Rating>> getAll({String? userId}) async {
    try {
      Query query = firestore.collection(collectionName);

      if (userId != null) {
        query = query.where('ratedBy', isEqualTo: userId).orderBy(
              'createdAt',
              descending: true,
            );
      }

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
}
