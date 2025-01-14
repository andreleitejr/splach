import 'package:splach/features/chat/models/group_chat.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/chat/repositories/participant_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class ChatRepository extends FirestoreRepository<GroupChat> {
  ChatRepository()
      : super(
          collectionName: 'chats',
          fromDocument: (document) => GroupChat.fromDocument(document),
        );

  @override
  Future<List<GroupChat>> getAll({String? userId}) async {
    final query = firestore.collection(collectionName);

    if (userId != null) {
      query.where('userId', isEqualTo: userId);
    }

    final querySnapshot = await query.get();
    final dataList =
        querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

    // Fetch participants for each chat
    for (var chat in dataList) {
      final chatId = chat.id;
      final participantsRepository = ParticipantRepository(chatId!);
      final participants =
          await participantsRepository.getLimitedParticipants();
      chat.participants = participants;
    }

    return dataList;
  }

  @override
  Stream<List<GroupChat>> streamAll({String? userId}) {
    const pageSize = 10;

    final query = firestore.collection(collectionName);

    if (userId != null) {
      query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().asyncMap((querySnapshot) async {
      final List<GroupChat> dataList = [];

      for (var i = 0; i < querySnapshot.docs.length; i += pageSize) {
        final chatDocs = querySnapshot.docs.skip(i).take(pageSize).toList();

        final batchQueries = <Future<List<Participant>>>[];

        for (var doc in chatDocs) {
          final chatId = doc.id;
          final participantRepository = ParticipantRepository(chatId);
          batchQueries.add(participantRepository.getLimitedParticipants());
        }

        final batchResults = await Future.wait(batchQueries);

        for (var j = 0; j < chatDocs.length; j++) {
          final chatDoc = chatDocs[j];
          final participants = batchResults[j];

          final chat = fromDocument(chatDoc);
          chat.participants = participants;
          dataList.add(chat);
        }
      }

      return dataList;
    });
  }

  void updateLastActivity(String documentId) {
    final documentReference =
        firestore.collection(collectionName).doc(documentId);

    Map<String, dynamic> data = {
      'lastActivity': DateTime.now(),
    };

    documentReference.update(data);
  }
}
