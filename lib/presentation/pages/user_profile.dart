import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/animated_toggle.dart';
import 'change_password_page.dart';
import '../components/info_card.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final double _avatarSize = 150.0;
  int _toggleValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD6E1FE),
      appBar: AppBar(
        title: const Text('My Profile'),
        foregroundColor: const Color(0xffD6E1FE),
        backgroundColor: const Color(0xff01113A),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.5),
              painter: CustomShape(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Container(
              height: _avatarSize,
              width: _avatarSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage('assets/images/yellow_stripe.png'), fit: BoxFit.scaleDown),
                boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 20.0)],
              ),
            ),
          ),
          Positioned(
              top: (MediaQuery.of(context).size.height * 0.1 + _avatarSize),
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0),
                child: Column(
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'Igor Alekhnovych',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Passport № FU304229',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24.0),
                    buildSettingsCard(
                      context: context,
                      title: 'Account Settings',
                      rows: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Email', style: Theme.of(context).textTheme.bodyLarge),
                            Text(FirebaseAuth.instance.currentUser?.email ?? 'placeholder@mail.com',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Password', style: Theme.of(context).textTheme.bodyLarge),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const ChangePasswordPage();
                                }));
                              },
                              child: Text(
                                'Change Password',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xff0037C3),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    AnimatedToggle(
                      values: const ['🇬🇧 English', ' 🇺🇦 Українська'],
                      onToggleCallback: (value) {
                        setState(() {
                          _toggleValue = value;
                        });
                      },
                      buttonColor: const Color(0xffB0C6FF),
                      backgroundColor: const Color(0xffE5EBFA),
                      //textColor: const Color(0xFFFFFFFF),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class CustomShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height * 0.15; // height of the curved part
    final width = size.width; // width of the screen
    final radius = height / 2; // radius of the bottom circle

    final paint = Paint()..color = const Color(0xffB0C6FF);

    final path = Path()
      ..moveTo(0, height) // move to top-left corner
      ..lineTo(0, 0) // line to top-right corner
      ..lineTo(width, 0) // line to bottom-right corner
      ..arcToPoint(Offset(width, height), radius: Radius.circular(radius)) // bottom-right curve
      ..quadraticBezierTo(width / 2, height * 2.5, 0, height) // curved part
      ..close(); // close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
