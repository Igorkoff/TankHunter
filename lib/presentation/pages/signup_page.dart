import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tank_hunter/data/firebase_database.dart';

import '../components/input_fields.dart';
import '../components/buttons.dart';
import '../components/snack_bar.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _passportNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _passportNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _passportNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  Future _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? errorMessage = await FirebaseDatabase.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _firstNameController.text,
        _lastNameController.text,
        _passportNumberController.text,
      );

      if (errorMessage != null) {
        FocusManager.instance.primaryFocus?.unfocus();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(messageText: errorMessage, isError: true));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/signup_background.jpg"), fit: BoxFit.cover, opacity: 0.25)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: KeyboardDismisser(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Join the Resistance!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                      const SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter your First Name',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12.0),
                            buildName(
                              context: context,
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              borderColor: const Color(0xff8F8787),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              inputStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              onSubmitted: () {
                                FocusScope.of(context).requestFocus(_lastNameFocusNode);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Text('Enter your Last Name',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12.0),
                            buildName(
                              context: context,
                              controller: _lastNameController,
                              focusNode: _lastNameFocusNode,
                              borderColor: const Color(0xff8F8787),
                              hintText: 'Example: Biden',
                              hintStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              inputStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              onSubmitted: () {
                                FocusScope.of(context).requestFocus(_passportNumberFocusNode);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Text('Enter your Passport Number',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12.0),
                            buildPassportNumber(
                              context: context,
                              controller: _passportNumberController,
                              focusNode: _passportNumberFocusNode,
                              borderColor: const Color(0xff8F8787),
                              hintStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              inputStyle:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                              onSubmitted: () {
                                FocusScope.of(context).requestFocus(_emailFocusNode);
                              },
                            ),
                            const SizedBox(height: 20.0),
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
                              onSubmitted: () {
                                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Text('Confirm your Password',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              obscureText: true,
                              focusNode: _confirmPasswordFocusNode,
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: 'confirm_password',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff8F8787)),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xff8F8787)),
                                    borderRadius: BorderRadius.circular(16.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xff8F8787)),
                                    borderRadius: BorderRadius.circular(16.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xff8F8787)),
                                    borderRadius: BorderRadius.circular(16.0)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.5),
                              ),
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'The field is required';
                                } else if (value != _passwordController.text) {
                                  return 'Please make sure your passwords match';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 40.0),
                            SizedBox(
                              width: double.infinity,
                              child: buildButton(
                                context: context,
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                title: 'Sign Up',
                                onPressed: _signUp,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already a Member? ',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: widget.showLoginPage,
                                  child: Text(
                                    'Login Now.',
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
