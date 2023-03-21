import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum CivilianPresence { yes, no, unknown }

class Report {
  Report();

  Report.create({
    required this.image,
    required this.userComment,
    required this.civilianPresence,
    required this.vehiclesDetected,
    required this.currentLocation,
    required this.currentDateTime,
  });

  File? image;
  String? userID = FirebaseAuth.instance.currentUser!.uid;
  String? userComment;
  String? civilianPresence;
  Position? currentLocation;
  DateTime? currentDateTime;
  Map? vehiclesDetected;
  bool isVerified = false;

  setImage(ImageSource source) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      this.image = File(image.path);
    } on PlatformException catch (e) {
      return Future.error('Failed to Pick Image: $e');
    }
  }

  setUserID(String value) {
    userID = value;
  }

  setUserComment(String value) {
    userComment = value;
  }

  setCivilianPresence(CivilianPresence value) {
    switch (value) {
      case CivilianPresence.yes:
        civilianPresence = 'Yes';
        break;
      case CivilianPresence.no:
        civilianPresence = 'No';
        break;
      case CivilianPresence.unknown:
        civilianPresence = 'Unknown';
        break;
    }
  }

  setVehiclesDetected(Map value) {
    if (value.isNotEmpty) {
      vehiclesDetected = value;
    }
  }

  setCurrentLocation() async {
    /*
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location Services are Disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are Denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permissions are Permanently Denied.');
    }
    */

    currentLocation = await Geolocator.getCurrentPosition();
  }

  setCurrentDateTime() {
    currentDateTime = DateTime.now();
  }

  setIsVerified(bool value) {
    isVerified = value;
  }

  reset() {
    image = null;
    userComment = null;
    civilianPresence = null;
    currentLocation = null;
    currentDateTime = null;
    vehiclesDetected = null;
  }
}
