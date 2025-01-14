import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splach/models/base_model.dart';

class User extends BaseModel {
  final String phone;
  final String email;
  final String nickname;
  final String? image;
  final String name;
  final String description;
  final String gender;
  final DateTime birthday;
  final String state;
  final String country;
  final String? instagram;

  int? rating;

  User({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
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
    this.instagram,
  });

  User.fromDocument(DocumentSnapshot document)
      : phone = document.get('phone'),
        email = document.get('email'),
        nickname = document.get('nickname'),
        image = document.get('image'),
        name = document.get('name'),
        description = document.get('description'),
        gender = document.get('gender'),
        birthday = (document.get('birthday') as Timestamp).toDate(),
        state = document.get('state'),
        country = document.get('country'),
        instagram = document.get('instagram'),
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
      'instagram': instagram,
      ...super.toMap(),
    };
  }

  bool get isCurrentUser => id == Get.find<User>().id;
}
