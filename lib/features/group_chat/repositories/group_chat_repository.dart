import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
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
    final dataList = querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

    // Fetch participants for each chat
    for (var chat in dataList) {
      final chatId = chat.id;
      final participantsRepository = ParticipantRepository(chatId!);
      final participants = await participantsRepository.getLimitedParticipants();
      chat.participants = participants;
    }

    return dataList;
  }
}
