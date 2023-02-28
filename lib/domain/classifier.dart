import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class Classifier {
  Classifier();

  late ImageLabeler _imageLabeler;

  create({assetPath, maxCount = 10, confidenceThreshold = 0.5}) async {
    final modelPath = await _getModel(assetPath);
    final options = LocalLabelerOptions(
      modelPath: modelPath,
      maxCount: maxCount,
      confidenceThreshold: confidenceThreshold,
    );
    _imageLabeler = ImageLabeler(options: options);
  }

  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<String> classify(File file) async {
    String result = "";
    final inputImage = InputImage.fromFile(file);
    final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += "$text – ${confidence.toStringAsFixed(2)}";
    }

    return result;
  }

  dispose() {
    _imageLabeler.close();
  }
}
