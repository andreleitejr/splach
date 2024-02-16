import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/repositories/firestore_repository.dart';

class GroupChatRepository extends FirestoreRepository<GroupChat> {
  GroupChatRepository()
      : super(
          collectionName: 'chats',
          fromDocument: (document) => GroupChat.fromDocument(document),
        );
}
