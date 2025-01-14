
import 'package:splach/features/report/models/report.dart';
import 'package:splach/repositories/firestore_repository.dart';
class ReportRepository extends FirestoreRepository<Report> {
  ReportRepository()
      : super(
          collectionName: 'reports',
          fromDocument: (document) => Report.fromDocument(document),
        );
}
