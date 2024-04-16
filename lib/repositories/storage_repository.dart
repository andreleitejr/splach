import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageRepository {
  StorageRepository({
    required this.name,
  });

  final String name;
  final storage = FirebaseStorage.instance;

  final reference = FirebaseStorage.instance.ref();

  Future<String?> upload(File image) async {
    final extension = path.extension(image.path);
    final uuid = const Uuid().v1();
    final fileName = uuid + extension;

    try {
      final ref = storage.ref(name).child(fileName);
      await ref.putFile(image);

      final downloadUrl = storage.ref(name).child(fileName).getDownloadURL();

      debugPrint('Storage Repository | Image Url: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('Storage Repository | Upload Error: $e');
      return null;
    }
  }

// Future<String?> download(String fileName) async {
//   final path = "$name/$fileName";
//
//   try {
//     final imageUrl = await reference.child(path).getDownloadURL();
//     return imageUrl;
//   } catch (e) {
//     debugPrint('Storage Repository | Download Error: $e');
//     return null;
//   }
// }

// Future<String?> uploadAndGetUrl(File file) async {
//   await upload(file);
//   final downloadUrl = await download(path.basename(file.path));
//   return downloadUrl;
// }
}
