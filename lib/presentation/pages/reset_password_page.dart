import 'package:flutter/material.dart';
import 'package:tank_hunter/data/firebase_database.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

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
            return const Center(child: CircularProgressIndicator(color: Color(0xff0037C3)));
          });

      await FirebaseDatabase.sendPasswordResetEmail(_emailController.text).then((value) {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ResetPasswordConfirmationPage();
          }));
        }
      }).catchError((e) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: 'Error: Unknown Error', isError: true));
        }
      });
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
          gestures: const [
            GestureType.onVerticalDragDown,
          ],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
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
                  Text('E-Mail Address', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 24.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildEmailAddress(context: context, emailAddressController: _emailController),
                        const SizedBox(height: 36.0),
                        SizedBox(
                          width: double.infinity,
                          child: buildSubmitButton(
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
