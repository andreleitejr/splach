import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:splach/features/chat/models/group_chat.dart';
import 'package:splach/features/chat/models/participant.dart';
import 'package:splach/features/notification/models/notification.dart';
import 'package:splach/features/chat/models/message.dart';
import 'package:splach/features/rating/models/rating.dart';
import 'package:splach/features/report/models/report.dart';

extension StringExtensions on String {
  String get clean => removeDiacritics(toLowerCase())
      .removeDots
      .removeHyphen
      .removeParenthesis
      .removeAllWhitespace;

  String get removeDots => replaceAll('.', '');

  String get removeHyphen => replaceAll('-', '');

  String get removeParenthesis => replaceAll(')', '').replaceAll('(', '');

  String toNickname() => '@$this';

  String capitalizeFirstLetter() {
    if (isEmpty) return this;

    return this[0].toUpperCase() + substring(1);
  }
}

extension DoubleExtension on double {
  String get formatDistance {
    if (this <= 999) {
      return '${toStringAsFixed(0)}m';
    } else {
      final distanceInKm = this / 1000;
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
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

  String toMonthlyAndYearFormattedString() {
    final day = this.day.toString();
    final month = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ][this.month - 1];
    final year = this.year.toString();

    return '$day de $month de $year';
  }
}

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

extension RatingTypeExtension on RatingType {
  String toStringSimplified() => toString().split('.').last;

  static RatingType fromString(String value) {
    switch (value) {
      case 'chat':
        return RatingType.chat;
      default:
        return RatingType.user;
    }
  }
}

extension StatusExtension on Status {
  String toStringSimplified() => toString().split('.').last;

  static Status fromString(String value) {
    switch (value) {
      case 'online':
        return Status.online;
      default:
        return Status.offline;
    }
  }
}

extension ReportTypeExtension on ReportType {
  String toStringSimplified() => toString().split('.').last;

  static ReportType fromString(String value) {
    switch (value) {
      case 'user':
        return ReportType.user;
      case 'chat':
        return ReportType.chat;
      default:
        return ReportType.message;
    }
  }
}

extension AppNotificationTypeExtension on AppNotificationType {
  String toStringSimplified() => toString().split('.').last;

  static AppNotificationType fromString(String value) {
    switch (value) {
      case 'rating':
        return AppNotificationType.rating;
      case 'mention':
        return AppNotificationType.mention;
      default:
        throw ArgumentError('Invalid NotificationType value');
    }
  }
}
