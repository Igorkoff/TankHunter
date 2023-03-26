import 'package:flutter/material.dart';
import 'package:tank_hunter/data/firebase_database.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'change_password_confirmation_page.dart';

import '../components/info_card.dart';
import '../components/input_fields.dart';
import '../components/my_buttons.dart';
import '../components/snack_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _oldPasswordFocusNode = FocusNode();

  final _newPasswordController = TextEditingController();
  final _newPasswordFocusNode = FocusNode();

  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _oldPasswordFocusNode.dispose();
    _newPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  Future _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator(color: Color(0xff0037C3)));
          });

      String? errorCode =
          await FirebaseDatabase.updatePassword(_oldPasswordController.text, _newPasswordController.text);

      if (errorCode != null) {
        String errorMessage = 'Error: Unknown Error';

        if (errorCode == 'wrong-password') {
          errorMessage = 'Error: User Not Found';
        } else if (errorCode == 'network-request-failed') {
          errorMessage = 'Error: No Internet Connection';
        }

        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        FocusManager.instance.primaryFocus?.unfocus();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: errorMessage, isError: true));
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return const ChangePasswordConfirmationPage();
              },
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD6E1FE),
      appBar: AppBar(
        title: const Text('Change Password'),
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
                    title: 'Create New Password',
                    text: 'If your password was compromised, you can update it below.',
                  ),
                  const SizedBox(height: 40.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Password', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 24.0),
                        buildPassword(
                          context: context,
                          passwordController: _oldPasswordController,
                          passwordFocusNode: _oldPasswordFocusNode,
                          onSubmitted: () {
                            FocusScope.of(context).requestFocus(_newPasswordFocusNode);
                          },
                        ),
                        const SizedBox(height: 36.0),
                        Text('New Password', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 24.0),
                        buildPassword(
                          context: context,
                          passwordController: _newPasswordController,
                          passwordFocusNode: _newPasswordFocusNode,
                          onSubmitted: () {
                            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                          },
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          obscureText: true,
                          focusNode: _confirmPasswordFocusNode,
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'confirm_password',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xff1D44A7)),
                                borderRadius: BorderRadius.circular(16.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xff1D44A7)),
                                borderRadius: BorderRadius.circular(16.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xff1D44A7)),
                                borderRadius: BorderRadius.circular(16.0)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.5),
                          ),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'The field is required';
                            } else if (value != _newPasswordController.text) {
                              return 'Please make sure your passwords match';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 36.0),
                        SizedBox(
                          width: double.infinity,
                          child: buildSubmitButton(
                            context: context,
                            title: 'Update Password',
                            onPressed: _updatePassword,
                          ),
                        ),
                        const SizedBox(height: 36.0),
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
