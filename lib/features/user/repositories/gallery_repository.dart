import 'package:get/get.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/firestore_repository.dart';

class GalleryRepository extends FirestoreRepository<Gallery> {
  GalleryRepository()
      : super(
          collectionName: 'users/${Get.find<User>().id}/gallery',
          fromDocument: (document) => Gallery.fromDocument(document),
        );
}
