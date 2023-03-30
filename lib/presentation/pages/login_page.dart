import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tank_hunter/data/firebase_database.dart';

import 'reset_password_page.dart';

import '../components/input_fields.dart';
import '../components/buttons.dart';
import '../components/snack_bar.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignupPage;
  const LoginPage({Key? key, required this.showSignupPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  Future _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(child: LoadingAnimationWidget.hexagonDots(color: const Color(0xff0037C3), size: 50));
          });

      String? errorMessage =
          await FirebaseDatabase.signInWithEmailAndPassword(_emailController.text, _passwordController.text);

      if (errorMessage != null) {
        _emailController.clear();
        _passwordController.clear();
        FocusManager.instance.primaryFocus?.unfocus();

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: errorMessage, isError: true));
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_background.png"), fit: BoxFit.cover, opacity: 0.25)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: KeyboardDismisser(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/tank_hunter_logo_white.png'),
                      const SizedBox(height: 75.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter your E-Mail Address',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12.0),
                            buildEmailAddress(
                              context: context,
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              borderColor: const Color(0xff8F8787),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              inputStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              onSubmitted: () {
                                FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Text('Enter your Password',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12.0),
                            buildPassword(
                              context: context,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              borderColor: const Color(0xff8F8787),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              inputStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return const ResetPasswordPage();
                                    }));
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: const Color(0xffF5DB53),
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40.0),
                            SizedBox(
                              width: double.infinity,
                              child: buildButton(
                                context: context,
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                title: 'Login',
                                onPressed: _login,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Not a Member? ',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: widget.showSignupPage,
                                  child: Text(
                                    'Register Now.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: const Color(0xffF5DB53),
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
