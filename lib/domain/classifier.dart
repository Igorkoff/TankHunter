import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class Classifier {
  Classifier();

  late ImageLabeler _imageLabeler;

  create({required assetPath, maxCount = 10, confidenceThreshold = 0.5}) async {
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

  Future<Map> classify(File file) async {
    Map<String, double> classifiedObjects = {};

    final inputImage = InputImage.fromFile(file);
    final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      num confidence = num.parse(label.confidence.toStringAsFixed(2));
      classifiedObjects[label.label] = confidence.toDouble();
    }

    // return empty collection if did not pass validation

    _validate(classifiedObjects);
    return classifiedObjects;
  }

  _validate(Map<String, double> objects) {
    if (objects.length == 1) {
      // if the only label is 'Other' or the only label is an AFV, but confidence score is below 40%
      if (objects.containsKey('Other') || objects.values.every((confidence) => confidence < 0.40)) {
        objects.clear();
      }
    } else if (objects.length > 1) {
      // if 'Other' has most confidence
      if (objects.keys.first == 'Other') {
        // if confidence score difference between 'Other' and AFV is more than 5%
        if (objects.values.elementAt(0) - objects.values.elementAt(1) > 0.05) {
          objects.clear();
        }
      }
    }
  }

  dispose() {
    _imageLabeler.close();
  }
}
