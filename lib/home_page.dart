import 'package:flutter/material.dart';
import 'package:tank_hunter/russian_losses.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const RussianLossesPage();
              },
            ),
          );
        },
        child: const Text('Russian Losses'),
      ),
    );
  }
}
