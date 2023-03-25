import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/my_buttons.dart';
import '../components/info_card.dart';

class ChangePasswordConfirmationPage extends StatefulWidget {
  const ChangePasswordConfirmationPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordConfirmationPage> createState() => _ChangePasswordConfirmationPageState();
}

class _ChangePasswordConfirmationPageState extends State<ChangePasswordConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xff01113A),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xffD6E1FE),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 175.0,
                    width: 175.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffB0C6FF),
                      boxShadow: [
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 20.0)
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_reset_outlined,
                      color: Color(0xff01113A),
                      size: 70.0,
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                buildInfoCard(
                  context: context,
                  title: 'Thank You',
                  text: 'Your password was successfully changed.',
                ),
                const SizedBox(height: 35.0),
                buildSubmitButton(
                  context: context,
                  title: 'Back Home',
                  width: 240,
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
