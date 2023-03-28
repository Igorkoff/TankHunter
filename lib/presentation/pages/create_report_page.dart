import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../../domain/report.dart';
import '../../domain/utility.dart';
import '../../domain/classifier.dart';
import '../../data/hive_database.dart';
import '../../data/firebase_database.dart';

import '../components/app_bar.dart';
import '../components/buttons.dart';
import '../components/snack_bar.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({Key? key}) : super(key: key);

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();

  FirebaseCustomModel? model; // object classification model
  String modelName = 'Tank-Classifier'; // local: 'assets/ml/vertex.tflite'

  Report report = Report(); // instance of report

  CivilianPresence civilianPresence = CivilianPresence.unknown; // default value for radio buttons
  Map? vehiclesDetected; // dictionary of AFV detected in a photo

  bool isInternetAvailable = false; // check if internet connection is available
  bool isImageValidated = false; // check if a user-taken photo has any AFV
  bool canProcess = false; // check if Firebase model is downloaded

  @override
  void initState() {
    super.initState();
    _initWithLocalModel();
    commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    Classifier.dispose();
    commentFocusNode.dispose();
    commentController.dispose();
  }

  Future _initWithLocalModel() async {
    if (Platform.isAndroid) {
      modelName = 'assets/ml/vertex.tflite';
      Classifier.createFromLocal(assetPath: modelName, confidenceThreshold: 0.20, maxCount: 3);
    } else {
      model = await FirebaseModelDownloader.instance
          .getModel(modelName, FirebaseModelDownloadType.localModelUpdateInBackground);
      Classifier.createFromFirebase(assetPath: model?.file.path, confidenceThreshold: 0.20, maxCount: 3);
    }
    canProcess = true;
    setState(() {});
  }

  Future _pickImage(ImageSource source) async {
    bool isPermitGranted = await Utility.requestPermissions();
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isPermitGranted && isServiceEnabled) {
      if (canProcess) {
        await _processImage(source);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: 'Error: Unknown Error', isError: true));
        }
      }
    }
  }

  Future _processImage(ImageSource source) async {
    await report.setImage(source); // pick image from camera or gallery and save it in report

    if (report.image != null) {
      setState(() {}); // update UI, set a preview image
      vehiclesDetected = await Classifier.classify(report.image!); // check for AFV presence

      // if no AFV detected
      if (vehiclesDetected!.isEmpty) {
        isImageValidated = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(buildSnackBar(messageText: 'Error: Military Vehicles not Found', isError: true));
        }
        // if at least a single AFV was detected
      } else {
        isImageValidated = true;
        debugPrint(vehiclesDetected.toString());
        report.setVehiclesDetected(vehiclesDetected!); // save the map with AFV detected
        await report.setCurrentLocation(); // set current location
        await report.setCurrentDateTime(); // set current time
      }
    } else {
      debugPrint('Image Not Selected');
      return;
    }
  }

  Future _submitReport() async {
    if (report.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: 'Error: Upload an Image', isError: true));
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
          return Center(child: LoadingAnimationWidget.hexagonDots(color: const Color(0xff0037C3), size: 50));
        });

    report.setUserComment(commentController.text);
    report.setCivilianPresence(civilianPresence);

    String resultMessage = 'Thank You for Your Service!';

    if (isInternetAvailable) {
      await FirebaseDatabase.uploadReport(report).timeout(const Duration(seconds: 10), onTimeout: () async {
        resultMessage = 'Report added to Pending Reports';
        File image = await Utility.saveImage(report.image!);
        HiveDatabase.savePendingReport(report, image);
      });
    } else {
      resultMessage = 'Report added to Pending Reports';
      File image = await Utility.saveImage(report.image!);
      HiveDatabase.savePendingReport(report, image);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: resultMessage, isError: false));

      commentController.clear(); // remove any text from the comment input
      civilianPresence = CivilianPresence.unknown; // reset the civilian presence radio buttons

      report = Report();
      setState(() {});
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
          GestureType.onVerticalDragDown,
        ],
        child: ListView(
          children: [
            buildAppBar(context: context, title: 'Report the Enemy'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildImagePicker(),
            ),
            const SizedBox(height: 40),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Additional Information', style: Theme.of(context).textTheme.labelLarge)),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildComment(),
            ),
            const SizedBox(height: 40),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Civilian Presence in the Area?', style: Theme.of(context).textTheme.labelLarge)),
            const SizedBox(height: 12),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: _buildRadioButton(title: 'Yes, there are some civilians.', value: CivilianPresence.yes)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: _buildRadioButton(title: 'No, there are no civilians.', value: CivilianPresence.no)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: _buildRadioButton(title: 'I don\'t know.', value: CivilianPresence.unknown)),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: buildButton(
                  context: context,
                  title: 'Submit',
                  onPressed: _submitReport,
                ),
              ),
            ),
            SizedBox(height: (MediaQuery.of(context).size.height * .18)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2.5,
        child: Ink(
          height: 225.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xff99B9F5),
          ),
          child: InkWell(
            onTap: () async {
              if (kDebugMode) {
                await _pickImage(ImageSource.gallery);
              } else if (kReleaseMode) {
                await _pickImage(ImageSource.camera);
              }
            },
            onLongPress: () async {
              await _pickImage(ImageSource.gallery);
            },
            child: report.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      report.image!,
                      fit: BoxFit.cover,
                      height: 225.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  )
                : canProcess
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(color: Color(0xffD6E1FE), Icons.add_a_photo, size: 45),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xffD6E1FE)),
                        ],
                      ),
          ),
        ),
      );

  Widget _buildComment() => TextFormField(
        focusNode: commentFocusNode,
        controller: commentController,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Share Details Here ...',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.5),
          suffixIcon: commentController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => commentController.clear(),
                ),
        ),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
      );

  Widget _buildRadioButton({
    required String title,
    required CivilianPresence value,
  }) =>
      RadioListTile<CivilianPresence>(
        contentPadding: EdgeInsets.zero,
        title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
        value: value,
        activeColor: const Color(0xff1D44A7),
        groupValue: civilianPresence,
        onChanged: (CivilianPresence? value) {
          setState(() {
            civilianPresence = value!;
          });
        },
      );
}
