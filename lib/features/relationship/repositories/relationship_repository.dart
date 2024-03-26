import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/repositories/firestore_repository.dart';

class RelationshipRepository extends FirestoreRepository<Relationship> {
  RelationshipRepository()
      : super(
          collectionName: 'relationships',
          fromDocument: (document) => Relationship.fromDocument(document),
        );

  @override
  Future<List<Relationship>> getAll({String? userId}) async {
    try {
      Query query = firestore.collection(collectionName);

      if (userId != null) {
        query = query.where('userIds', arrayContains: userId);
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
