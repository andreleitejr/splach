import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/models/base_model.dart';
import 'package:splach/utils/extensions.dart';

enum ReportType {
  message,
  user,
  chat,
}

class Report extends BaseModel {
  final String reason;
  final String? comments;
  final String reportedId;

  // final String userId;
  final ReportType type;

  Report({
    required super.createdAt,
    required super.updatedAt,
    required this.reason,
    required this.comments,
    required this.reportedId,
    // required this.userId,
    required this.type,
    // this.status = SupportStatus.open,
    // required this.phone,
    // this.isWhatsApp = true,
  });

  Report.fromDocument(DocumentSnapshot document)
      : reason = document['reason'],
        comments = document['comments'],
        reportedId = document['reportedId'],
        // userId = document['userId'],
        type = ReportTypeExtension.fromString(document['type']),
        // phone = document['phone'],
        // isWhatsApp = document['isWhatsApp'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'reason': reason,
      'comments': comments,
      'reportedId': reportedId,
      'userId': Get.find<User>().id,
      'type': type.toStringSimplified(),
      // 'status': status.toStringSimplified(),
      // 'phone': phone,
      // 'isWhatsApp': isWhatsApp,
      ...super.toMap(),
    };
  }
}
