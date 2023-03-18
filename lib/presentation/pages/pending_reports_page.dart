import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tank_hunter/data/hive_database.dart';
import 'package:tank_hunter/data/firebase_database.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../../domain/pending_report.dart';

class PendingReportsPage extends StatefulWidget {
  const PendingReportsPage({Key? key}) : super(key: key);

  @override
  State<PendingReportsPage> createState() => _PendingReportsPageState();
}

class _PendingReportsPageState extends State<PendingReportsPage> {
  late Box<PendingReport> _pendingReportsBox;
  final StreamController _timerController = StreamController.broadcast();
  bool isInternetAvailable = false; // check if internet connection is available

  @override
  void initState() {
    super.initState();
    _pendingReportsBox = HiveDatabase.getPendingReportsBox();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _removeExpiredReports();
      _timerController.add(DateTime.now());

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    //_timerController.close();
    super.dispose();
  }

  Future _removeExpiredReports() async {
    final now = DateTime.now();
    HiveDatabase.getAllPendingReports().forEach((pendingReport) async {
      if (now.difference(pendingReport.currentDateTime).inHours >= 12) {
        await HiveDatabase.deletePendingReport(pendingReport);
      }
    });
  }

  Future _uploadPendingReports() async {
    if (HiveDatabase.getPendingReportsBox().isNotEmpty) {
      List<PendingReport> pendingReports = HiveDatabase.getAllPendingReports();
      await Future.forEach(pendingReports, (pendingReport) async {
        await FirebaseDatabase.uploadPendingReport(pendingReport);
        await HiveDatabase.deletePendingReport(pendingReport);
      });
    }
    return;
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
      child: Center(
        child: ValueListenableBuilder<Box>(
          valueListenable: _pendingReportsBox.listenable(),
          builder: (context, box, _) {
            final pendingReports = HiveDatabase.getAllPendingReports();
            if (pendingReports.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    const Text('Pending Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Pull to Upload'),
                    const SizedBox(height: 16),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if (isInternetAvailable) {
                            await _uploadPendingReports();
                            debugPrint('Uploaded');
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _buildSnackBar(messageText: 'Error: No Internet Connection', isError: true));
                            }
                          }
                        },
                        child: ListView.separated(
                          //padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                          itemCount: pendingReports.length,
                          itemBuilder: (context, index) {
                            final pendingReport = pendingReports[index];
                            final thumbnail = File(pendingReport.imagePath);

                            final DateTime expirationDateTime =
                                pendingReport.currentDateTime.add(const Duration(hours: 12));
                            final Duration difference = expirationDateTime.difference(DateTime.now());
                            return Dismissible(
                              key: Key(pendingReport.key.toString()),
                              onDismissed: (direction) async {
                                await HiveDatabase.deletePendingReport(pendingReport);
                              },
                              background: _buildSwipeActionRight(),
                              direction: DismissDirection.endToStart,
                              dismissThresholds: const {DismissDirection.endToStart: 0.7},
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                elevation: 0,
                                child: ListTile(
                                  leading: Image.file(thumbnail, width: 80.0, height: 80.0, fit: BoxFit.cover),
                                  title: Text('Report №${index + 1}'),
                                  subtitle: Text(pendingReport.vehiclesDetected.keys.join(', ').replaceAll('_', '-')),
                                  trailing: Text(
                                      '${difference.inHours.toString().padLeft(2, "0")} : ${difference.inMinutes.remainder(60).toString().padLeft(2, "0")}'),
                                  //tileColor: const Color.fromRGBO(85, 98, 131, 1),
                                  //textColor: const Color.fromRGBO(255, 253, 250, 1),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(thickness: 0.5);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No Pending Reports'));
            }
          },
        ),
      ),
    );
  }
}

Widget _buildSwipeActionRight() => Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.red,
      child: Icon(Icons.delete, color: const Color.fromRGBO(255, 253, 250, 1)),
    );

SnackBar _buildSnackBar({
  required String messageText,
  required bool isError,
}) =>
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: isError ? const Duration(seconds: 3) : const Duration(seconds: 1),
      content: Text(messageText),
    );
