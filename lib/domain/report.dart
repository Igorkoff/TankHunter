import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Report {
  Report({required this.image, required this.currentLocation, required this.currentDateTime});

  late File image;
  late String userComment;
  late Position currentLocation;
  late DateTime currentDateTime;
  bool isVerified = false;

  // TODO: implement compass direction (smooth_compass or flutter_compass)
  // TODO: implement dictionary of objects returned from object detector

  setImage(ImageSource source) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      this.image = File(image.path);
    } on PlatformException catch (e) {
      return Future.error('Failed to Pick Image: $e');
    }
  }

  setUserComment(String value) {
    userComment = value;
  }

  setCurrentLocation() async {
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

    currentLocation = await Geolocator.getCurrentPosition();
  }

  setCurrentDateTime() {
    currentDateTime = DateTime.now();
  }

  setIsVerified(bool value) {
    isVerified = value;
  }
}
