import 'package:flutter/material.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/utils/extensions.dart';

class ParticipantRepository extends FirestoreRepository<Participant> {
  ParticipantRepository(String chatId)
      : super(
          collectionName: 'chats/$chatId/participants',
          fromDocument: (document) => Participant.fromDocument(document),
        );

  Stream<List<Participant>> streamParticipants({int limit = 200}) {
    try {
      debugPrint(
          'Message Repository | Listen to last messages of  $collectionName');

      final query = firestore
          .collection(collectionName)
          .where('status', isEqualTo: Status.online.toStringSimplified())
          .limit(limit);

      final stream = query.snapshots().map(
        (querySnapshot) {
          final dataList =
              querySnapshot.docs.map((doc) => fromDocument(doc)).toList();
          return dataList;
        },
      );

      return stream;
    } catch (error) {
      print('Error streaming data from $collectionName in Firestore: $error');
      return Stream.value([]);
    }
  }

  Future<List<Participant>> getLimitedParticipants({
    int limit = 200,
  }) async {
    final query = firestore.collection(collectionName);

    final querySnapshot = await query
        .where('status', isEqualTo: Status.online.toStringSimplified())
        .limit(limit)
        .get();
    final dataList =
        querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

    return dataList;
  }
}
