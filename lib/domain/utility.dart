import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Utility {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

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

  static Future<bool> requestPermissions() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    } else if (cameraStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    PermissionStatus galleryStatus;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        galleryStatus = await Permission.storage.request();
        if (galleryStatus.isDenied) {
          await Permission.storage.request();
        } else if (galleryStatus.isPermanentlyDenied) {
          openAppSettings();
        }
      } else {
        galleryStatus = await Permission.photos.request();
        if (galleryStatus.isDenied) {
          await Permission.photos.request();
        } else if (galleryStatus.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    } else {
      galleryStatus = await Permission.photos.request();
      if (galleryStatus.isDenied) {
        await Permission.photos.request();
      } else if (galleryStatus.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      openAppSettings();
    }

    if (cameraStatus.isDenied || galleryStatus.isDenied || permission == LocationPermission.denied) {
      return false;
    } else {
      return true;
    }
  }
}
