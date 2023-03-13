import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../../domain/classifier.dart';
import '../../domain/report.dart';
import '../../data/firebase.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();

  FirebaseCustomModel? model;
  String modelName = 'Tank-Classifier'; // 'assets/ml/vertex.tflite'

  Classifier classifier = Classifier();
  Report report = Report();

  CivilianPresence civilianPresence = CivilianPresence.unknown;

  Map? vehiclesDetected;
  File? previewImage;

  bool isInternetAvailable = false;
  bool isImageValidated = false;
  bool canProcess = false;

  @override
  void initState() {
    super.initState();
    initWithLocalModel();

    commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    classifier.dispose();
    commentFocusNode.dispose();
    commentController.dispose();
  }

  initWithLocalModel() async {
    model = await FirebaseModelDownloader.instance
        .getModel(modelName, FirebaseModelDownloadType.localModelUpdateInBackground);

    classifier.createFromFirebase(assetPath: model?.file.path, confidenceThreshold: 0.20, maxCount: 3);
    canProcess = true;
    setState(() {});
  }

  Future pickImage(ImageSource source) async {
    await report.setImage(source);

    if (report.image != null) {
      setState(() => previewImage = report.image);
      vehiclesDetected = await classifier.classify(report.image!);

      if (vehiclesDetected!.isEmpty) {
        isImageValidated = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(buildSnackBar(messageText: 'Error: Military Vehicles not Found', isError: true));
        }
      } else {
        isImageValidated = true;
        debugPrint(vehiclesDetected.toString());
        report.setVehiclesDetected(vehiclesDetected!);
        await report.setCurrentLocation();
        await report.setCurrentDateTime();
      }
    } else {
      debugPrint('Image Not Selected');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectivityListener(
      connectivityListener: (BuildContext context, bool hasInternetAccess) {
        if (hasInternetAccess) {
          isInternetAvailable = true;
        } else {
          isInternetAvailable = false;
        }
      },
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onVerticalDragDown,
        ],
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(
              child: Column(
                children: [
                  Text('Report the Enemy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 24),
                ],
              ),
            ),
            MaterialButton(
              height: 220,
              padding: EdgeInsets.zero,
              shape: previewImage != null ? const Border(top: BorderSide.none) : Border.all(color: Colors.grey),
              onPressed: () async {
                if (canProcess) {
                  await pickImage(ImageSource.gallery);
                } else {
                  debugPrint('An Error with Firebase Model');
                }
              },
              onLongPress: () async {
                if (canProcess) {
                  await pickImage(ImageSource.camera);
                } else {
                  debugPrint('An Error with Firebase Model');
                }
              },
              child: previewImage != null
                  ? Image.file(previewImage!, fit: BoxFit.cover)
                  : canProcess
                      ? const Column(
                          children: [
                            Icon(Icons.add_a_photo, size: 40),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Take a Photo'),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(color: Colors.black87),
            ),
            const SizedBox(height: 24),
            buildComment(),
            const SizedBox(height: 24),
            const Text(
              'Civilian Presence in the Area?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            buildRadioButton(title: 'Yes, there are some civilians.', value: CivilianPresence.yes),
            buildRadioButton(title: 'No, there are no civilians.', value: CivilianPresence.no),
            buildRadioButton(title: 'I don\'t know.', value: CivilianPresence.unknown),
            const SizedBox(height: 12),
            buildButton(
                title: 'Submit Report',
                icon: Icons.add_location,
                onClicked: () async {
                  if (previewImage == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(buildSnackBar(messageText: 'Error: Upload an Image', isError: true));
                    return;
                  } else if (!isImageValidated) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(buildSnackBar(messageText: 'Error: Military Vehicles not Found', isError: true));
                    return;
                  }

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });

                  report.setUserComment(commentController.text);
                  report.setCivilianPresence(civilianPresence);

                  if (isInternetAvailable) {
                    await Database.uploadReport(report);
                  } else {
                    debugPrint('you are kinda cringe ngl');
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(buildSnackBar(messageText: 'Thank You for Your Service!', isError: false));

                    previewImage = null; // remove the current preview image
                    commentController.clear(); // remove any text from the comment input
                    civilianPresence = CivilianPresence.unknown; // reset the civilian presence radio buttons

                    report = Report();
                    setState(() {});
                  }
                }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  SnackBar buildSnackBar({
    required String messageText,
    required bool isError,
  }) =>
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: isError ? const Duration(seconds: 3) : const Duration(seconds: 1),
        content: Text(messageText),
      );

  Widget buildComment() => TextFormField(
        focusNode: commentFocusNode,
        controller: commentController,
        minLines: 1,
        maxLines: 4,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          labelText: 'Comment (Optional)',
          prefixIcon: const Icon(Icons.comment),
          suffixIcon: commentController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => commentController.clear(),
                ),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
      );

  Widget buildRadioButton({
    required String title,
    required CivilianPresence value,
  }) =>
      RadioListTile<CivilianPresence>(
        title: Text(title),
        value: value,
        activeColor: Colors.black87,
        groupValue: civilianPresence,
        onChanged: (CivilianPresence? value) {
          setState(() {
            civilianPresence = value!;
          });
        },
      );

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: onClicked,
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
      );
}
