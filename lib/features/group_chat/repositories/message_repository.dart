import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splach/features/group_chat/models/message.dart';
import 'package:splach/repositories/firestore_repository.dart';

class MessageRepository extends FirestoreRepository<Message> {
  MessageRepository(String chatId)
      : super(
          collectionName: 'chats/$chatId/messages',
          fromDocument: (document) => Message.fromDocument(document),
        );


  /// MODIFICAR ESSA STREAM PARA EVITAR BUSCAS DE MENSAGENS PRIVADAS
  /// EM QUE O USER NAO ESTA NA LISTA DE RECIPIENTS

  Stream<List<Message>> streamLastMessages() {
    try {
      debugPrint(
          'Message Repository | Listen to last messages of  $collectionName');

      final query = firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true)
          .limit(100);

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
