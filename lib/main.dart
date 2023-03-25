import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tank_hunter/presentation/pages/auth_page.dart';
import 'package:tank_hunter/presentation/pages/report_page.dart';
import 'package:tank_hunter/presentation/pages/user_awards_page.dart';
import 'package:tank_hunter/presentation/pages/pending_reports_page.dart';
import 'package:tank_hunter/presentation/pages/enemy_losses_page.dart';
import 'package:tank_hunter/presentation/components/my_navigation_drawer.dart';

import 'domain/enemy_losses.dart';
import 'domain/pending_report.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffD6E1FE),
        textTheme: GoogleFonts.montserratTextTheme(textTheme).copyWith(
          titleLarge:
              GoogleFonts.montserrat(textStyle: textTheme.titleLarge, fontSize: 20.0, fontWeight: FontWeight.w600),
          titleMedium:
              GoogleFonts.montserrat(textStyle: textTheme.titleMedium, fontSize: 16.0, fontWeight: FontWeight.w500),
          titleSmall:
              GoogleFonts.montserrat(textStyle: textTheme.titleSmall, fontSize: 14.0, fontWeight: FontWeight.w500),
          labelLarge:
              GoogleFonts.montserrat(textStyle: textTheme.labelLarge, fontSize: 18.0, fontWeight: FontWeight.w500),
          labelMedium:
              GoogleFonts.montserrat(textStyle: textTheme.labelMedium, fontSize: 14.0, fontWeight: FontWeight.w500),
          bodyLarge:
              GoogleFonts.montserrat(textStyle: textTheme.bodyLarge, fontSize: 16.0, fontWeight: FontWeight.w300),
          bodyMedium:
              GoogleFonts.montserrat(textStyle: textTheme.bodyMedium, fontSize: 14.0, fontWeight: FontWeight.w300),
        ),
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
    EnemyLosses.dio.close();
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

  final List<DotNavigationBarItem> _destinations = [
    DotNavigationBarItem(icon: const Icon(Icons.camera_alt_outlined)),
    DotNavigationBarItem(icon: const Icon(Icons.drive_file_move_outlined)),
    DotNavigationBarItem(icon: const Icon(Icons.folder_special_outlined)),
    DotNavigationBarItem(icon: const Icon(Icons.person_off_outlined)),
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xff01113A),
      ),
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: PageView(
            onPageChanged: (index) {
              pageChanged(index);
            },
            controller: _pageController,
            children: _pages),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: buildPageView(),
      drawer: const MyNavigationDrawer(),
      bottomNavigationBar: DotNavigationBar(
        borderRadius: 40,
        enablePaddingAnimation: false,
        backgroundColor: const Color(0xff01113A),
        selectedItemColor: const Color(0xffF5DB53),
        unselectedItemColor: const Color(0xffD6E1FE),
        paddingR: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 10.0),
        marginR: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        itemPadding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 16.0),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(25, 44, 94, 0.4), offset: Offset(0, 4), blurRadius: 15.0)],
        items: _destinations,
        currentIndex: _currentPage,
        onTap: (int index) {
          destinationSelected(index);
        },
      ),
    );
  }
}
