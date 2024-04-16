import 'package:flutter/material.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/repositories/firestore_repository.dart';
import 'package:splach/repositories/storage_repository.dart';
import 'package:splach/utils/extensions.dart';

class MessageStorageRepository extends StorageRepository {
  MessageStorageRepository()
      : super(
          name: 'messages',
        );
}
