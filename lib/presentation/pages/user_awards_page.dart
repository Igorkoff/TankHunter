import 'package:flutter/material.dart';

class UserAwardsPage extends StatefulWidget {
  const UserAwardsPage({Key? key}) : super(key: key);

  @override
  State<UserAwardsPage> createState() => _UserAwardsPageState();
}

class _UserAwardsPageState extends State<UserAwardsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Awards'),
    );
  }
}
