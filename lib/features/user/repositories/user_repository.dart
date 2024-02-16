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

    // Acesse o Firebase para obter dados dos usuários com base nos IDs
    // Suponha que você tenha uma coleção chamada "users" no Firestore
    // e cada documento tenha um campo "id" e um campo "name"

    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    usersData.addAll(querySnapshot.docs.map((doc) => User.fromDocument(doc)));

    return usersData;
  }
}
