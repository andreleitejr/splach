import 'package:cloud_firestore/cloud_firestore.dart';

class BaseModel {
  String? id;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseModel({
    this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  BaseModel.fromDocument(DocumentSnapshot document)
      : id = document.id,
        createdAt = (document.get('createdAt') as Timestamp).toDate(),
        updatedAt = (document.get('updatedAt') as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toUtc(),
      'updatedAt': DateTime.now(),
    };
  }
}
