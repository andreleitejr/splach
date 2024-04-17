import 'package:get/get.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/storage_repository.dart';

class GalleryStorageRepository extends StorageRepository {
  GalleryStorageRepository()
      : super(
          name: 'users/${Get.find<User>().id}/gallery',
        );
}
