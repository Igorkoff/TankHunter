import 'package:flutter/material.dart';

class RussianLossesPage extends StatefulWidget {
  const RussianLossesPage({Key? key}) : super(key: key);

  @override
  State<RussianLossesPage> createState() => _RussianLossesPageState();
}

class _RussianLossesPageState extends State<RussianLossesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Russian Losses'),
      ),
    );
  }
}
