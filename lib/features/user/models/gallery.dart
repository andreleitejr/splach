// imageUrl: URL da imagem armazenada no Firebase Storage.
// description: Descrição da foto.
// timestamp: Timestamp do momento em que a foto foi enviada.
// likes: Número de curtidas na foto.
// comments: Lista de comentários na foto.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splach/models/base_model.dart';

class Gallery extends BaseModel {
  final String image;
  final String description;

  Gallery({
    required super.createdAt,
    required super.updatedAt,
    required this.image,
    required this.description,
  });

  Gallery.fromDocument(DocumentSnapshot document)
      : image = document.get('image'),
        description = document.get('description'),
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'description': description,
      ...super.toMap(),
    };
  }
}
