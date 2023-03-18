import 'package:hive/hive.dart';
part 'pending_report.g.dart';

@HiveType(typeId: 0)
class PendingReport extends HiveObject {
  PendingReport();

  PendingReport.create({
    required this.imagePath,
    required this.userID,
    required this.userComment,
    required this.civilianPresence,
    required this.vehiclesDetected,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.currentDateTime,
    required this.isVerified,
  });

  @HiveField(0)
  late String imagePath;

  @HiveField(1)
  late String userID;

  @HiveField(2)
  late String userComment;

  @HiveField(3)
  late String civilianPresence;

  @HiveField(4)
  late double locationLatitude;

  @HiveField(5)
  late double locationLongitude;

  @HiveField(6)
  late DateTime currentDateTime;

  @HiveField(7)
  late Map vehiclesDetected;

  @HiveField(8)
  late bool isVerified;

  @override
  String toString() {
    return "($userID, $vehiclesDetected)";
  }
}
