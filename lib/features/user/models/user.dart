import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/address/models/address.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/models/base_model.dart';

class User extends BaseModel {
  final String image;
  final String email;
  final String document;
  final String firstName;
  final String lastName;
  final String nickname;
  final String phone;
  final String gender;
  final DateTime birthday;
  final Address address;

  List<Relationship> followers = [];
  List<Relationship> following = [];

  User({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.email,
    required this.image,
    required this.document,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.phone,
    required this.gender,
    required this.birthday,
    required this.address,
    // required this.type,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  User.fromDocument(DocumentSnapshot document)
      : image = document['image'],
        email = document['email'],
        document = document['document'],
        firstName = document['firstName'],
        lastName = document['lastName'],
        nickname = document['nickname'],
        phone = document['phone'],
        gender = document['gender'],
        birthday = (document['birthday'] as Timestamp).toDate(),
        address = Address.fromMap(document['address']),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'image': image,
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'phone': phone,
      'gender': gender,
      'birthday': birthday.toUtc(),
      'address': address.toMap(),
      // 'type': type,
      ...super.toMap(),
    };
  }
}
