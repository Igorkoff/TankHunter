import 'dart:io';
import 'package:hive/hive.dart';

import '../domain/report.dart';
import '../domain/utility.dart';
import '../domain/pending_report.dart';

class HiveDatabase {
  static final Box _pendingReportsBox = getPendingReportsBox();

  static Box<PendingReport> getPendingReportsBox() {
    return Hive.box<PendingReport>('pending_reports');
  }

  static List<PendingReport> getAllPendingReports() {
    return _pendingReportsBox.values.toList().cast<PendingReport>();
  }

  static PendingReport getPendingReportByKey(key) {
    return _pendingReportsBox.get(key);
  }

  static PendingReport getPendingReportByIndex(int index) {
    return _pendingReportsBox.getAt(index);
  }

  static savePendingReport(Report report, File image) {
    final pendingReport = PendingReport.create(
      imagePath: image.path,
      userID: report.userID!,
      userComment: report.userComment!,
      civilianPresence: report.civilianPresence!,
      vehiclesDetected: report.vehiclesDetected!,
      locationLatitude: report.currentLocation!.latitude,
      locationLongitude: report.currentLocation!.longitude,
      currentDateTime: report.currentDateTime!,
      isVerified: report.isVerified,
    );

    _pendingReportsBox.add(pendingReport);
  }

  static deletePendingReport(PendingReport pendingReport) async {
    await Utility.deleteImage(pendingReport.imagePath);
    pendingReport.delete();
  }

  static deleteAllPendingReports() async {
    if (_pendingReportsBox.isNotEmpty) {
      getAllPendingReports().forEach((pendingReport) async {
        await deletePendingReport(pendingReport);
      });
    }
  }
}
