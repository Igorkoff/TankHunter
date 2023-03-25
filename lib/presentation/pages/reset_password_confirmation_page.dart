import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tank_hunter/presentation/components/my_buttons.dart';
import 'package:tank_hunter/presentation/pages/auth_page.dart';

import '../components/info_card.dart';

class ResetPasswordConfirmationPage extends StatefulWidget {
  const ResetPasswordConfirmationPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordConfirmationPage> createState() => _ResetPasswordConfirmationPageState();
}

class _ResetPasswordConfirmationPageState extends State<ResetPasswordConfirmationPage> {
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
            padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 0.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 190.0,
                    width: 190.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffB0C6FF),
                      boxShadow: [
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 20.0)
                      ],
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_rounded,
                      color: Color(0xff01113A),
                      size: 80.0,
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                buildInfoCard(
                  context: context,
                  title: 'Check Your E-Mail',
                  text: 'We have sent password recover instructions to your email address.',
                ),
                const SizedBox(height: 35.0),
                buildSubmitButton(
                  context: context,
                  title: 'Back to Login',
                  width: 240,
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return const AuthPage();
                    }));
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 52.0, 16.0, 4.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Did not receive the email from us? Check your spam folder or ',
                      style: Theme.of(context).textTheme.labelMedium,
                      children: [
                        TextSpan(
                            text: 'try another email address.',
                            style: const TextStyle(color: Color(0xff1D44A7)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
