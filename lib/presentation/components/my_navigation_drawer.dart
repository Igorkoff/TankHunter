import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tank_hunter/data/hive_database.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../pages/user_profile.dart';
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
        color: const Color(0xff01113A),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Column(
            children: [
              DrawerItem(
                name: 'My Profile',
                icon: Icons.person_outline,
                onPressed: () => onItemPressed(context, index: 0),
              ),
              DrawerItem(
                name: 'About Us',
                icon: Icons.info_outline,
                onPressed: () => onItemPressed(context, index: 1),
              ),
              const Divider(
                color: Colors.white,
                height: 50,
              ),
              DrawerItem(
                name: 'Sign Out',
                icon: Icons.logout_outlined,
                onPressed: () => onItemPressed(context, index: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onItemPressed(BuildContext context, {required int index}) async {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const UserProfilePage();
        }));
        break;
      case 1:
        const url = 'https://github.com/Igorkoff/TankHunter';
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not Launch $url';
        }
        break;
      case 2:
        await HiveDatabase.deleteAllPendingReports();
        FirebaseAuth.instance.signOut();
        debugPrint('Signed Out');
        break;
    }
  }
}
