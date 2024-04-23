import 'package:get/get.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/storage_repository.dart';

class UserStorageRepository extends StorageRepository {
  UserStorageRepository()
      : super(
          name: 'users/${Get.isRegistered<User>() ? Get.find<User>().id : ''}',
        );
}
