import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'domain/report.dart';
import 'data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Report report = Report();
  File? image;

  Future pickImage(ImageSource source) async {
    await report.setImage(source);
    await report.setCurrentLocation();
    report.setUserComment('Test');
    report.setCurrentDateTime();

    setState(() => image = report.image);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            const Spacer(),
            image != null
                ? Image.file(
                    image!,
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  )
                : const FlutterLogo(size: 160),
            const SizedBox(height: 48),
            buildButton(
              title: 'Pick Gallery',
              icon: Icons.image_outlined,
              onClicked: () => pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 24),
            buildButton(
              title: 'Pick Camera',
              icon: Icons.camera_alt_outlined,
              onClicked: () => pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type Comment',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload an Image')));
                  return;
                }
                await Database.uploadReport(report);
                setState(() {
                  image = null;
                });
              },
              child: const Text('Submit Report'),
            ),
            const SizedBox(height: 12),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

Widget buildButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 20),
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
