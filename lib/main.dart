import 'package:flutter/material.dart';
import 'package:tank_hunter/home_page.dart';
import 'package:tank_hunter/profile_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TankHunter());
}

class TankHunter extends StatelessWidget {
  TankHunter({Key? key}) : super(key: key);

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(255, 253, 250, 1),
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('You Have an Error! ${snapshot.error.toString()}');
            return const Text('Something Went Wrong!');
          } else if (snapshot.hasData) {
            return const RootPage();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = [
    HomePage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tank Hunter'),
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.add_a_photo, color: Colors.white), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.person_off, color: Colors.white), label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
