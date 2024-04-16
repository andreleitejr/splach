import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/firestore_repository.dart';

class UserRepository extends FirestoreRepository<User> {
  UserRepository()
      : super(
          collectionName: 'users',
          fromDocument: (document) => User.fromDocument(document),
        );

  Future<List<User>> getUsersByIds(List<String> userIds) async {
    List<User> usersData = [];

    // debugPrint('User Repository | Getting the following users: $userIds');
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    // debugPrint(
    //     'User Repository | Got users by ids. Total users: ${querySnapshot.docs.length}');

    usersData.addAll(querySnapshot.docs.map((doc) => User.fromDocument(doc)));

    return usersData;
  }
}
