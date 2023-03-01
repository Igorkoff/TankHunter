import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../domain/classifier.dart';
import '../../domain/report.dart';
import '../../data/firebase.dart';

// TODO: some feedback for user

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();

  Classifier classifier = Classifier();
  Report report = Report();

  CivilianPresence civilianPresence = CivilianPresence.unknown;

  Map? vehiclesDetected;
  File? previewImage;

  bool isImageValidated = false;

  @override
  void initState() {
    super.initState();

    commentController.addListener(() => setState(() {}));
    classifier.create(assetPath: 'assets/ml/vertex.tflite', confidenceThreshold: 0.20, maxCount: 3);
  }

  @override
  void dispose() {
    super.dispose();
    classifier.dispose();
    commentFocusNode.dispose();
    commentController.dispose();
  }

  Future pickImage(ImageSource source) async {
    await report.setImage(source);

    if (report.image != null) {
      setState(() => previewImage = report.image);
      vehiclesDetected = await classifier.classify(report.image!);

      if (vehiclesDetected!.isEmpty) {
        isImageValidated = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text('Error: Military Vehicles not Found'),
          ));
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
    return KeyboardDismisser(
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
              await pickImage(ImageSource.gallery);
            },
            onLongPress: () async {
              await pickImage(ImageSource.camera);
            },
            child: previewImage != null
                ? Image.file(previewImage!, fit: BoxFit.cover)
                : const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Take a Photo'),
                      ),
                    ],
                  ),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                    content: Text('Error: Upload an Image'),
                  ));
                  return;
                } else if (!isImageValidated) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                    content: Text('Error: Military Vehicles not Found'),
                  ));
                  return;
                }

                showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    });

                report.setUserComment(commentController.text);
                report.setCivilianPresence(civilianPresence);
                await Database.uploadReport(report);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                      content: Text('Thank You for Your Service!'),
                    ),
                  );

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
    );
  }

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
