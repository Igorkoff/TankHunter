import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:tank_hunter/data/hive_database.dart';
import 'package:tank_hunter/data/firebase_database.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

import '../../domain/pending_report.dart';

import '../components/app_bar.dart';
import '../components/snack_bar.dart';
import '../components/info_card.dart';

class PendingReportsPage extends StatefulWidget {
  const PendingReportsPage({Key? key}) : super(key: key);

  @override
  State<PendingReportsPage> createState() => _PendingReportsPageState();
}

class _PendingReportsPageState extends State<PendingReportsPage> {
  final int _hoursToExpire = 12; // how many hours user has to upload report
  late bool _isInternetAvailable; // check if internet connection is available
  late Box<PendingReport> _pendingReportsBox; // initialize the pending reports box
  final StreamController _timerController = StreamController.broadcast(); // necessary for timer updating

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

  Future _removeExpiredReports() async {
    if (_pendingReportsBox.isNotEmpty) {
      final now = DateTime.now();
      final List<PendingReport> pendingReports = HiveDatabase.getAllPendingReports();
      await Future.forEach(pendingReports, (pendingReport) async {
        if (now.difference(pendingReport.currentDateTime).inHours >= _hoursToExpire) {
          await HiveDatabase.deletePendingReport(pendingReport);
        }
      });
    }
    return;
  }

  Future _uploadPendingReports() async {
    if (_pendingReportsBox.isNotEmpty) {
      final List<PendingReport> pendingReports = HiveDatabase.getAllPendingReports();
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
          _isInternetAvailable = true;
        } else {
          _isInternetAvailable = false;
        }
      },
      child: ValueListenableBuilder<Box>(
        valueListenable: _pendingReportsBox.listenable(),
        builder: (context, box, _) {
          final pendingReports = HiveDatabase.getAllPendingReports();
          if (pendingReports.isNotEmpty) {
            return RefreshIndicator(
              color: const Color(0xff0037C3),
              onRefresh: () async {
                if (_isInternetAvailable) {
                  await _uploadPendingReports();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(buildSnackBar(messageText: 'Error: No Internet Connection', isError: true));
                  }
                }
              },
              child: ListView(
                children: [
                  buildAppBar(context: context, title: 'Pending Reports', subtitle: 'Pull to Upload'),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height * .18)),
                    itemCount: pendingReports.length,
                    itemBuilder: (context, index) {
                      final pendingReport = pendingReports[index];
                      return _SwipeableCard(
                        index: index,
                        pendingReport: pendingReport,
                        hoursToExpire: _hoursToExpire,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 14.0);
                    },
                  ),
                ],
              ),
            );
          } else {
            return ListView(
              children: [
                buildAppBar(context: context, title: 'Pending Reports', subtitle: 'Nothing to Upload'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildIconInfoCard(
                    context: context,
                    icon: Icons.done,
                    text: 'Thanks, you do not have any reports waiting to be uploaded.',
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _SwipeableCard extends StatefulWidget {
  const _SwipeableCard({
    Key? key,
    required this.pendingReport,
    required this.hoursToExpire,
    required this.index,
  }) : super(key: key);

  final PendingReport pendingReport;
  final int hoursToExpire;
  final int index;

  @override
  State<_SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<_SwipeableCard> {
  @override
  Widget build(BuildContext context) {
    final thumbnail = File(widget.pendingReport.imagePath);
    final String vehiclesDetected = widget.pendingReport.vehiclesDetected.keys.join(', ').replaceAll('_', '-');
    final DateTime expirationDateTime = widget.pendingReport.currentDateTime.add(Duration(hours: widget.hoursToExpire));
    final Duration timeBeforeExpiration = expirationDateTime.difference(DateTime.now());
    final String timeBeforeExpirationInHours = timeBeforeExpiration.inHours.toString().padLeft(2, "0");
    final String timeBeforeExpirationInMinutes =
        timeBeforeExpiration.inMinutes.remainder(60).toString().padLeft(2, "0");
    return SwipeableTile.card(
      borderRadius: 16.0,
      swipeThreshold: 0.4,
      color: const Color(0xffE5EBFA),
      key: Key(widget.pendingReport.key.toString()),
      onSwiped: (direction) async {
        await HiveDatabase.deletePendingReport(widget.pendingReport);
      },
      backgroundBuilder: (context, direction, progress) {
        return _buildSwipeActionRight();
      },
      verticalPadding: 0,
      horizontalPadding: 16,
      shadow: BoxShadow(color: Colors.black.withOpacity(0.05)),
      direction: SwipeDirection.endToStart,
      child: Card(
          color: const Color(0xffE5EBFA),
          elevation: 0,
          child: _buildListTile(
            context: context,
            index: widget.index,
            thumbnail: thumbnail,
            vehiclesDetected: vehiclesDetected,
            timeBeforeExpirationInHours: timeBeforeExpirationInHours,
            timeBeforeExpirationInMinutes: timeBeforeExpirationInMinutes,
          )),
    );
  }
}

Widget _buildListTile({
  required context,
  required int index,
  required File thumbnail,
  required String vehiclesDetected,
  required String timeBeforeExpirationInHours,
  required String timeBeforeExpirationInMinutes,
}) =>
    ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          thumbnail,
          width: 90.0,
          height: 55.0,
          cacheWidth: (90 * MediaQuery.of(context).devicePixelRatio).round(),
          fit: BoxFit.cover,
        ),
      ),
      title: Text('Report ${(index + 1).toString().padLeft(2, "0")}'),
      subtitle: Text(vehiclesDetected),
      trailing: Text('$timeBeforeExpirationInHours : $timeBeforeExpirationInMinutes'),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,
    );

Widget _buildSwipeActionRight() => Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(color: Colors.red),
      child: const Icon(Icons.delete, color: Color.fromRGBO(255, 253, 250, 1)),
    );
