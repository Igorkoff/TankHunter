import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tank_hunter/presentation/pages/auth_page.dart';
import 'package:tank_hunter/presentation/pages/report_page.dart';
import 'package:tank_hunter/presentation/pages/user_awards_page.dart';
import 'package:tank_hunter/presentation/pages/pending_reports_page.dart';
import 'package:tank_hunter/presentation/pages/enemy_losses_page.dart';
import 'package:tank_hunter/presentation/components/my_navigation_drawer.dart';

import 'domain/pending_report.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(PendingReportAdapter());
  await Hive.openBox<PendingReport>('pending_reports');
  runApp(TankHunter());
}

class TankHunter extends StatelessWidget {
  TankHunter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(255, 253, 250, 1),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('You Have an Error! ${snapshot.error.toString()}');
            return const Text('Something Went Wrong!');
          } else if (snapshot.hasData) {
            return const RootPage();
          } else {
            return const AuthPage();
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

  void dispose() {
    Hive.box<PendingReport>('pending_reports').close();
  }
}

class _RootPageState extends State<RootPage> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const ReportPage(),
    const PendingReportsPage(),
    const UserAwardsPage(),
    const EnemyLossesPage(),
  ];

  final List<GButton> _destinations = [
    const GButton(icon: Icons.camera_alt, text: 'Report'),
    const GButton(icon: Icons.drive_file_move, text: 'Pending'),
    const GButton(icon: Icons.folder_special, text: 'Awards'),
    const GButton(icon: Icons.person_off, text: 'Losses'),
  ];

  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void destinationSelected(int index) {
    setState(() {
      _currentPage = index;
      _pageController.jumpToPage(index);
    });
  }

  Widget buildPageView() {
    return PageView(
        onPageChanged: (index) {
          pageChanged(index);
        },
        controller: _pageController,
        children: _pages);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Tank Hunter'),
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      ),
      body: buildPageView(),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(32, 42, 68, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: GNav(
            gap: 10.0,
            haptic: false,
            padding: const EdgeInsets.all(12.0),
            color: const Color.fromRGBO(255, 253, 250, 1),
            activeColor: const Color.fromRGBO(255, 253, 250, 1),
            backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
            tabBackgroundColor: const Color.fromRGBO(85, 98, 131, 1),
            tabs: _destinations,
            selectedIndex: _currentPage,
            onTabChange: (int index) {
              destinationSelected(index);
            },
          ),
        ),
      ),
    );
  }
}
