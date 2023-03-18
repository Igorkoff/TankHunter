// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingReportAdapter extends TypeAdapter<PendingReport> {
  @override
  final int typeId = 0;

  @override
  PendingReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingReport()
      ..imagePath = fields[0] as String
      ..userID = fields[1] as String
      ..userComment = fields[2] as String
      ..civilianPresence = fields[3] as String
      ..locationLatitude = fields[4] as double
      ..locationLongitude = fields[5] as double
      ..currentDateTime = fields[6] as DateTime
      ..vehiclesDetected = (fields[7] as Map).cast<dynamic, dynamic>()
      ..isVerified = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, PendingReport obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.userComment)
      ..writeByte(3)
      ..write(obj.civilianPresence)
      ..writeByte(4)
      ..write(obj.locationLatitude)
      ..writeByte(5)
      ..write(obj.locationLongitude)
      ..writeByte(6)
      ..write(obj.currentDateTime)
      ..writeByte(7)
      ..write(obj.vehiclesDetected)
      ..writeByte(8)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
