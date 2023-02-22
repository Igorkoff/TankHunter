import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/alert_dialog.dart';
import '../components/input_fields.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    late String alertDialogMessage;
    late String alertDialogTitle;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      if (context.mounted) {
        alertDialogTitle = 'Email Has Been Sent';
        alertDialogMessage = 'Please check your inbox and click in the received link to reset a password.';
        showDialog(
          context: context,
          builder: (context) {
            return buildAlertDialog(
              context: context,
              title: alertDialogTitle,
              message: alertDialogMessage,
            );
          },
        );
      }
    } on FirebaseAuthException catch (exception) {
      debugPrint(exception.toString());
      alertDialogTitle = 'An Error Has Occurred';
      alertDialogMessage = 'Unfortunately, we cannot find user record for the email address provided.';
      showDialog(
        context: context,
        builder: (context) {
          return buildAlertDialog(
            context: context,
            title: alertDialogTitle,
            message: alertDialogMessage,
          );
        },
      );
      _emailFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 250, 1),
      appBar: AppBar(
        title: const Text('Reset Password'),
        foregroundColor: const Color.fromRGBO(255, 253, 250, 1),
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Your Password?',
                  style: GoogleFonts.bebasNeue(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Enter your registered email below to receive password reset instructions.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildEmailAddress(
                        emailAddressController: _emailController,
                        emailAddressFocusNode: _emailFocusNode,
                        emailAddressAutofocus: true,
                        onSubmitted: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            passwordReset();
                          } else {
                            _emailFocusNode.requestFocus();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remember Password? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: const Text(
                        'Login Here.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
