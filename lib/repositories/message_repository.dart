import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/models/message.dart';
import 'package:splach/repositories/firestore_repository.dart';

class MessageRepository extends FirestoreRepository<Message> {
  MessageRepository(String chatId)
      : super(
          collectionName: 'chats/$chatId/messages',
          fromDocument: (document) => Message.fromDocument(document),
        );

  Stream<List<Message>> streamLastMessages() {
    try {
      Query query = firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true)
          .limit(200);

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
}
