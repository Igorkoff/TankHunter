import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tank_hunter/presentation/pages/auth_page.dart';
import 'package:tank_hunter/presentation/pages/report_page.dart';
import 'package:tank_hunter/presentation/pages/losses_page.dart';
import 'package:tank_hunter/presentation/components/my_navigation_drawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
}

class _RootPageState extends State<RootPage> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const LossesPage(),
  ];

  final List<Widget> _destinations = [
    const NavigationDestination(icon: Icon(Icons.add_a_photo, color: Colors.white), label: 'Report'),
    const NavigationDestination(icon: Icon(Icons.person_off, color: Colors.white), label: 'Losses'),
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
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
        destinations: _destinations,
        onDestinationSelected: (int index) {
          destinationSelected(index);
        },
        selectedIndex: _currentPage,
      ),
    );
  }
}
