import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/features/group_chat/models/participant.dart';
import 'package:splach/features/group_chat/repositories/participant_repository.dart';
import 'package:splach/repositories/firestore_repository.dart';

class GroupChatRepository extends FirestoreRepository<GroupChat> {
  GroupChatRepository()
      : super(
          collectionName: 'chats',
          fromDocument: (document) => GroupChat.fromDocument(document),
        );

  late ParticipantRepository _participantRepository;

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
    // Defina o tamanho da página para a paginação
    final int pageSize = 10;

    final query = firestore.collection(collectionName);

    if (userId != null) {
      query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().asyncMap((querySnapshot) async {
      final List<GroupChat> dataList = [];

      // Processa os documentos em lotes de pageSize
      for (var i = 0; i < querySnapshot.docs.length; i += pageSize) {
        final chatDocs = querySnapshot.docs.skip(i).take(pageSize).toList();

        // Lista para armazenar as consultas batch
        final batchQueries = <Future<List<Participant>>>[];

        // Adiciona as consultas batch para buscar os participantes para cada chat
        for (var doc in chatDocs) {
          final chatId = doc.id;
          final participantRepository = ParticipantRepository(chatId);
          batchQueries.add(participantRepository.getLimitedParticipants());
        }

        // Executa as consultas batch
        final batchResults = await Future.wait(batchQueries);

        // Processa os resultados das consultas batch
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
    // Referência ao documento que deseja atualizar
    final documentReference =
        firestore.collection(collectionName).doc(documentId);

    // Dados que você deseja atualizar
    Map<String, dynamic> data = {
      'lastActivity': DateTime.now(),
    };

    // Atualiza apenas o campo especificado, sem substituir os outros campos
    documentReference.update(data);
  }
}
