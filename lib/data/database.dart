import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../domain/report.dart';

class Database {
  static Future<String> uploadImage(File image) async {
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
    final imageURL = await uploadImage(report.image!);
    final CollectionReference collection = FirebaseFirestore.instance.collection('reports');

    Map<String, dynamic> dataToSend = {
      'image': imageURL,
      'comment': report.userComment!,
      'civilians': report.civilianPresence!,
      'location': GeoPoint(report.currentLocation!.latitude, report.currentLocation!.longitude),
      'heading': report.currentLocation!.heading,
      'time': report.currentDateTime!,
      'verified': report.isVerified,
    };

    try {
      collection.add(dataToSend).then((documentSnapshot) => print("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      return Future.error('Failed to Upload Report to Firebase: $e');
    }
  }
}
