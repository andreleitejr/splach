import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/group_chat/models/group_chat.dart';
import 'package:splach/models/message.dart';

extension GeoPointExtension on GeoPoint {
  Position toPosition() {
    return Position(
      latitude: latitude,
      longitude: longitude,
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      timestamp: DateTime.now(),
    );
  }
}

extension DateTimeExtensions on DateTime {
  String toTimeString() {
    final timeDifference = DateTime.now().difference(this).inSeconds;
    if (timeDifference < 60) {
      return '${timeDifference.toStringAsFixed(0)}s';
    } else if (timeDifference < 3600) {
      final minutes = timeDifference / 60.toInt();
      return '${minutes.toStringAsFixed(0)}m';
    } else if (timeDifference < 86400) {
      final hours = timeDifference / 3600.toInt();
      return '${hours.toStringAsFixed(0)}h';
    } else {
      final days = timeDifference / 86400.toInt();
      return '${days.toStringAsFixed(0)}d';
    }
  }
}

extension StringExtensions on String {
  String get clean => removeDiacritics(toLowerCase())
      .removeDots
      .removeHyphen
      .removeParenthesis
      .removeAllWhitespace;

  String get removeDots => replaceAll('.', '');

  String get removeHyphen => replaceAll('-', '');

  String get removeParenthesis => replaceAll(')', '').replaceAll('(', '');
}

extension GroupTypeExtension on GroupType {
  String toStringSimplified() => toString().split('.').last;

  static GroupType fromString(String value) {
    switch (value) {
      case 'private':
        return GroupType.private;
      default:
        return GroupType.public;
    }
  }
}

extension MessageTypeExtension on MessageType {
  String toStringSimplified() => toString().split('.').last;

  static MessageType fromString(String value) {
    switch (value) {
      case 'system':
        return MessageType.system;
      default:
        return MessageType.user;
    }
  }
}
