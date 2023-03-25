import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/pending_report.dart';
import '../domain/report.dart';

class FirebaseDatabase {
  static Future sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      return Future.error('Failed to Send Password Reset Email: $e');
    }
  }

  static Future<String> _uploadImage(File image) async {
    final String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference referenceRoot = FirebaseStorage.instance.ref();
    final Reference referenceDirImages = referenceRoot.child('images');
    final Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(image);
      return await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      return Future.error('Failed to Upload Image to Firebase: $e');
    }
  }

  static Future uploadReport(Report report) async {
    final imageURL = await _uploadImage(report.image!);
    final CollectionReference collection = FirebaseFirestore.instance.collection('reports');

    Map<String, dynamic> dataToSend = {
      'image': imageURL,
      'user': report.userID,
      'comment': report.userComment,
      'civilians': report.civilianPresence,
      'vehicles': report.vehiclesDetected,
      'location': GeoPoint(report.currentLocation!.latitude, report.currentLocation!.longitude),
      'time': report.currentDateTime,
      'verified': report.isVerified,
    };

    try {
      collection.add(dataToSend).then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      return Future.error('Failed to Upload Report to Firebase: $e');
    }
  }

  static Future uploadPendingReport(PendingReport pendingReport) async {
    final imageURL = await _uploadImage(File(pendingReport.imagePath));
    final CollectionReference collection = FirebaseFirestore.instance.collection('reports');

    Map<String, dynamic> dataToSend = {
      'image': imageURL,
      'user': pendingReport.userID,
      'comment': pendingReport.userComment,
      'civilians': pendingReport.civilianPresence,
      'vehicles': pendingReport.vehiclesDetected,
      'location': GeoPoint(pendingReport.locationLatitude, pendingReport.locationLongitude),
      'time': pendingReport.currentDateTime,
      'verified': pendingReport.isVerified,
    };

    try {
      collection.add(dataToSend).then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      return Future.error('Failed to Upload Report to Firebase: $e');
    }
  }
}
