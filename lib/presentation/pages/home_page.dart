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
  File? image;

  @override
  void initState() {
    super.initState();
    classifier.create(assetPath: 'assets/ml/vertex.tflite', confidenceThreshold: 0.20, maxCount: 3);
    commentController.addListener(() => setState(() {}));
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
      vehiclesDetected = await classifier.classify(report.image!);

      if (vehiclesDetected!.isEmpty) {
        // TODO: prompt user to take another photo
      } else {
        report.setVehiclesDetected(vehiclesDetected!);
        await report.setCurrentLocation();
        await report.setCurrentDateTime();
      }
      debugPrint(vehiclesDetected.toString());
      setState(() => image = report.image);
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
            shape: image != null ? const Border(top: BorderSide.none) : Border.all(color: Colors.grey),
            onPressed: () async {
              await pickImage(ImageSource.gallery);
              if (context.mounted && image != null) {
                FocusScope.of(context).requestFocus(commentFocusNode);
              }
            },
            onLongPress: () async {
              await pickImage(ImageSource.camera);
              if (context.mounted && image != null) {
                FocusScope.of(context).requestFocus(commentFocusNode);
              }
            },
            child: image != null
                ? Image.file(image!, fit: BoxFit.cover)
                : const Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                    size: 45,
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
                if (image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                    content: Text('Error: Upload an Image'),
                  ));
                  return;
                }

                report.setUserComment(commentController.text);
                report.setCivilianPresence(civilianPresence);
                await Database.uploadReport(report);

                if (context.mounted) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                      content: Text('Thank You for Your Service!'),
                    ),
                  );

                  setState(() {
                    report.reset();
                    image = null;
                    commentController.clear();
                    civilianPresence = CivilianPresence.unknown;
                  });
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
