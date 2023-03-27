import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tank_hunter/data/firebase_database.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'reset_password_confirmation_page.dart';

import '../components/info_card.dart';
import '../components/input_fields.dart';
import '../components/my_buttons.dart';
import '../components/snack_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: LoadingAnimationWidget.hexagonDots(color: const Color(0xff0037C3), size: 50));
          });

      try {
        await FirebaseDatabase.sendPasswordResetEmail(_emailController.text);
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ResetPasswordConfirmationPage();
          }));
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
        String errorMessage = 'Error: Unknown Error';

        if (e.code == 'user-not-found') {
          errorMessage = 'Error: User Not Found';
        } else if (e.code == 'network-request-failed') {
          errorMessage = 'Error: No Internet Connection';
        }

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: errorMessage, isError: true));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD6E1FE),
      appBar: AppBar(
        title: const Text('Reset Password'),
        foregroundColor: const Color(0xffD6E1FE),
        backgroundColor: const Color(0xff01113A),
        centerTitle: true,
      ),
      body: SafeArea(
        child: KeyboardDismisser(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoCard(
                    context: context,
                    title: 'Forgot Your Password?',
                    text: 'Enter your registered email below to receive password reset instructions.',
                  ),
                  const SizedBox(height: 40.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('E-Mail Address', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 24.0),
                        buildEmailAddress(context: context, controller: _emailController),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: double.infinity,
                          child: buildButton(
                              context: context, title: 'Send Instructions', onPressed: _sendPasswordResetEmail),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
