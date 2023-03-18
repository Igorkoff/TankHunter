import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Utility {
  static Future<File> saveImage(File image) async {
    try {
      final Directory appSupportDirectory = await getApplicationSupportDirectory(); // get the app support folder
      final String appSupportPath = appSupportDirectory.path; // get the path to the app support folder
      final String newImagePath = path.join(appSupportPath, path.basename(image.path));
      return await image.copy(newImagePath); // return locally saved image
    } catch (e) {
      return Future.error('Failed to Save Image: $e');
    }
  }

  static Future deleteImage(String imagePath) async {
    try {
      final image = File(imagePath); // get the image from the image path
      await image.delete(); // delete the image from memory
    } catch (e) {
      return Future.error('Failed to Delete Image: $e');
    }
  }
}
