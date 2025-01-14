import 'package:get/get.dart';
import 'package:splach/features/user/models/gallery.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/firestore_repository.dart';

class GalleryRepository extends FirestoreRepository<Gallery> {
  GalleryRepository(User user)
      : super(
          collectionName: 'users/${user.id}/gallery',
          fromDocument: (document) => Gallery.fromDocument(document),
        );
}
