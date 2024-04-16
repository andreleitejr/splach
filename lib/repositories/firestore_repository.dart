import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:splach/models/base_model.dart';

enum SaveResult {
  success,
  failed,
}

class FirestoreRepository<T extends BaseModel> {
  final firestore = FirebaseFirestore.instance;
  final String collectionName;
  final T Function(DocumentSnapshot) fromDocument;

  FirestoreRepository({
    required this.collectionName,
    required this.fromDocument,
  });

  Future<SaveResult> save(T data, {String? docId}) async {
    try {
      await firestore.collection(collectionName).doc(docId).set(data.toMap());
      return SaveResult.success;
    } catch (error) {
      debugPrint('Error saving data to Firestore: $error');
      return SaveResult.failed;
    }
  }

  Future<String?> saveAndGetId(T data, {String? docId}) async {
    try {
      final docReference =
          await firestore.collection(collectionName).add(data.toMap());
      final docSnapshot = await docReference.get();
      final docId = docSnapshot.id;
      return docId;
    } catch (error) {
      debugPrint('Error saving data and getting id from Firestore: $error');
      return null;
    }
  }

  Future<T?> get(String documentId) async {
    try {
      final document =
          await firestore.collection(collectionName).doc(documentId).get();
      return fromDocument(document);
    } catch (error) {
      debugPrint(
          'Error getting data from $collectionName in Firestore: $error');

      return null;
    }
  }

  Future<List<T>> getAll({String? userId}) async {
    try {
      Query query = firestore.collection(collectionName);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
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

  // Future<List<T>> getGroup() async {
  //   try {
  //     final querySnapshot = await firestore
  //         .collectionGroup(collectionName.lastSegmentAfterSlash)
  //         .get();
  //
  //     print(
  //         '${collectionName.lastSegmentAfterSlash} Registros encontrados com sucesso ${querySnapshot.docs}');
  //     return querySnapshot.docs.map((doc) => fromDocument(doc)).toList();
  //   } catch (error) {
  //     print('Erro ao buscar grupo: $error');
  //     return [];
  //   }
  // }

  Future<SaveResult> update(T document) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(document.id)
          .update(document.toMap());

      return SaveResult.success;
    } catch (error) {
      debugPrint('Error updating document in Firestore: $error');

      return SaveResult.failed;
    }
  }

  Future<void> delete(String documentId) async {
    try {
      await firestore.collection(collectionName).doc(documentId).delete();
    } catch (error) {
      debugPrint('Error deleting document from Firestore: $error');
    }
  }

  Stream<T> stream(String id) {
    try {
      final query = firestore.collection(collectionName).doc(id);

      final stream = query.snapshots().map(
            (documentSnapshot) => fromDocument(documentSnapshot),
          );

      return stream;
    } catch (error) {
      debugPrint('Error streaming data from $collectionName in Firestore: $error');
      return Stream.error(error);
    }
  }

  Stream<List<T>> streamAll({String? userId}) {
    try {
      Query query = firestore.collection(collectionName);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
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
      debugPrint('Error streaming data from $collectionName in Firestore: $error');
      return Stream.value([]);
    }
  }
}
