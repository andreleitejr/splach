import 'package:splach/repositories/storage_repository.dart';

class MessageStorageRepository extends StorageRepository {
  MessageStorageRepository()
      : super(
          name: 'messages',
        );
}
