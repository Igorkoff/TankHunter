import 'dart:io';
import 'package:hive/hive.dart';

import '../domain/report.dart';
import '../domain/utility.dart';
import '../domain/pending_report.dart';

class HiveDatabase {
  static Box<PendingReport> getPendingReportsBox() {
    return Hive.box<PendingReport>('pending_reports');
  }

  static List<PendingReport> getAllPendingReports() {
    return getPendingReportsBox().values.toList().cast<PendingReport>();
  }

  static PendingReport? getPendingReportByKey(key) {
    return getPendingReportsBox().get(key);
  }

  static PendingReport? getPendingReportByIndex(int index) {
    return getPendingReportsBox().getAt(index);
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

    getPendingReportsBox().add(pendingReport);
  }

  static deletePendingReport(PendingReport pendingReport) async {
    await Utility.deleteImage(pendingReport.imagePath);
    pendingReport.delete();
  }

  static deleteAllPendingReports() async {
    if (getPendingReportsBox().isNotEmpty) {
      await Future.forEach(getAllPendingReports(), (pendingReport) async {
        await deletePendingReport(pendingReport);
      });
    }
  }
}
