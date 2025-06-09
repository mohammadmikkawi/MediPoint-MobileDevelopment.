import 'package:cloud_firestore/cloud_firestore.dart';
import 'report_model.dart';

class ReportController {
  final CollectionReference reportsRef = FirebaseFirestore.instance.collection('reports');

  Future<ReportModel?> fetchReport(String userEmail) async {
    try {
      final doc = await reportsRef.doc(userEmail).get();
      if (doc.exists) {
        return ReportModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
    }
  }

  Future<void> saveReport(ReportModel report) async {
    try {
      await reportsRef.doc(report.userEmail).set(report.toJson());
    } catch (e) {
      print('Error saving report: $e');
    }
  }

  Future<void> updateReport(ReportModel report) async {
    try {
      await reportsRef.doc(report.userEmail).update(report.toJson());
    } catch (e) {
      print('Error updating report: $e');
    }
  }

  Future<void> deleteReport(String userEmail) async {
    try {
      await reportsRef.doc(userEmail).delete();
    } catch (e) {
      print('Error deleting report: $e');
    }
  }
}
