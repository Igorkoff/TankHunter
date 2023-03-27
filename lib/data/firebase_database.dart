import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/pending_report.dart';
import '../domain/report.dart';

class FirebaseDatabase {
  static final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  static final CollectionReference _reportsCollection = FirebaseFirestore.instance.collection('reports');

  static Future<String?> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName, String passportNumber) async {
    Map<String, String?> codeResponses = {
      "email-already-in-use": null,
      "invalid-email": null,
      "operation-not-allowed": null,
      "weak-password": null,
    };

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await userCredential.user?.updateDisplayName('${firstName.trim()} ${lastName.trim()}');
      await _uploadUserDetails(firstName.trim(), lastName.trim(), passportNumber.trim(), userCredential.user!.uid);
      return null;
    } on FirebaseAuthException catch (error) {
      return codeResponses[error.code] ?? "Unknown";
    }
  }

  static Future _uploadUserDetails(String firstName, String lastName, String passportNumber, String userID) async {
    final userDocument = _usersCollection.doc(userID);

    Map<String, dynamic> dataToSend = {
      'passport_number': passportNumber,
      'first_name': firstName,
      'last_name': lastName,
      'verified_reports': 0,
    };

    try {
      userDocument.set(dataToSend).then((documentSnapshot) => debugPrint("Added Data with ID: $userID"));
    } catch (e) {
      return Future.error('Failed to Upload User Details to Firebase: $e');
    }
  }

  static Future<String?> signInWithEmailAndPassword(String email, String password) async {
    Map<String, String?> codeResponses = {
      "invalid-email": null,
      "user-disabled": null,
      "user-not-found": null,
      "wrong-password": null,
    };

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      return null;
    } on FirebaseAuthException catch (error) {
      return codeResponses[error.code] ?? "Unknown";
    }
  }

  static Future<String?> updatePassword(String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword.trim());

    Map<String, String?> codeResponses = {
      "user-mismatch": null,
      "user-not-found": null,
      "invalid-credential": null,
      "invalid-email": null,
      "wrong-password": null,
      "invalid-verification-code": null,
      "invalid-verification-id": null,
      "weak-password": null,
      "requires-recent-login": null
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword.trim());
      return null;
    } on FirebaseAuthException catch (error) {
      return codeResponses[error.code] ?? "Unknown";
    }
  }

  static Future sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  }

  static Future<Map<String, dynamic>> getUserDetails(String userID) async {
    try {
      final userDocument = await _usersCollection.doc(userID).get();
      if (userDocument.exists) {
        return userDocument.data() as Map<String, dynamic>;
      } else {
        throw Exception('User Details Not Found');
      }
    } catch (e) {
      debugPrint('Failed to Get User Details: $e');
      rethrow;
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
      _reportsCollection
          .add(dataToSend)
          .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      return Future.error('Failed to Upload Report to Firebase: $e');
    }
  }

  static Future uploadPendingReport(PendingReport pendingReport) async {
    final imageURL = await _uploadImage(File(pendingReport.imagePath));

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
      _reportsCollection
          .add(dataToSend)
          .then((documentSnapshot) => debugPrint("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      return Future.error('Failed to Upload Report to Firebase: $e');
    }
  }
}
