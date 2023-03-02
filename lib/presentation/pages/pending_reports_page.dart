import 'package:flutter/material.dart';

class PendingReportsPage extends StatefulWidget {
  const PendingReportsPage({Key? key}) : super(key: key);

  @override
  State<PendingReportsPage> createState() => _PendingReportsPageState();
}

class _PendingReportsPageState extends State<PendingReportsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pending Reports'),
    );
  }
}
