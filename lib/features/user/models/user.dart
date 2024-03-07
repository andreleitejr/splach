import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/features/address/models/address.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/models/base_model.dart';

class User extends BaseModel {
  final String phone;
  final String email;
  final String nickname;
  final String image;
  final String name;
  final String description;
  final String gender;
  final DateTime birthday;
  final String state;
  final String country;

  List<Relationship> followers = [];
  List<Relationship> following = [];

  User({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.phone,
    required this.email,
    required this.nickname,
    required this.image,
    required this.name,
    required this.description,
    required this.gender,
    required this.birthday,
    required this.state,
    required this.country,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  User.fromDocument(DocumentSnapshot document)
      : phone = document['phone'],
        email = document['email'],
        nickname = document['nickname'],
        image = document['image'],
        name = document['name'],
        description = document['description'],
        gender = document['gender'],
        birthday = (document['birthday'] as Timestamp).toDate(),
        state = document['state'],
        country = document['country'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'nickname': nickname,
      'image': image,
      'name': name,
      'description': description,
      'gender': gender,
      'birthday': birthday.toUtc(),
      'state': state,
      'country': country,
      ...super.toMap(),
    };
  }
}
