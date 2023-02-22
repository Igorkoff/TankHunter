import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tank_hunter/main.dart';
import 'drawer_item.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(32, 42, 68, 1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Column(
            children: [
              DrawerItem(
                name: 'My Profile',
                icon: Icons.person,
                onPressed: () => onItemPressed(context, index: 0),
              ),
              DrawerItem(
                name: 'About Us',
                icon: Icons.info,
                onPressed: () => onItemPressed(context, index: 1),
              ),
              const Divider(
                color: Colors.white,
                height: 50,
              ),
              DrawerItem(
                name: 'Sign Out',
                icon: Icons.logout,
                onPressed: () => onItemPressed(context, index: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);

    switch (index) {
      case 2:
        FirebaseAuth.instance.signOut();
        debugPrint('Signed Out');
        break;
    }
  }
}
