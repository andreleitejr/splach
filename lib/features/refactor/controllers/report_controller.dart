import 'package:get/get.dart';
import 'package:splach/features/refactor/models/report.dart';
import 'package:splach/features/refactor/repositories/support_repository.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/repositories/firestore_repository.dart';

class ReportController extends GetxController {
  ReportController({
    required this.type,
    required this.reportedId,
    required this.reason,
    this.comments,
  });

  final User user = Get.find();

  final _repository = Get.put(ReportRepository());

  ReportType type;
  String reportedId;
  String reason;
  String? comments;

  final loading = false.obs;

  Future<SaveResult> save() async {
    loading(true);

    final support = Report(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      comments: comments,
      reason: reason,
      type: type,
      reportedId: reportedId,
    );

    final result = await _repository.save(support);

    loading(false);
    return result;
  }
}
