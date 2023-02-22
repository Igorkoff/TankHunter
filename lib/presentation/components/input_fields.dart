import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

Widget buildEmailAddress({
  required TextEditingController emailAddressController,
  required FocusNode emailAddressFocusNode,
  final String? emailAddressLabelText,
  final Function()? onSubmitted,
  bool emailAddressAutofocus = false,
}) =>
    TextFormField(
      autocorrect: false,
      autofocus: emailAddressAutofocus,
      focusNode: emailAddressFocusNode,
      controller: emailAddressController,
      decoration: InputDecoration(
        labelText: emailAddressLabelText ?? 'Email Address',
        prefixIcon: const Icon(Icons.email),
        border: const OutlineInputBorder(),
      ),
      validator: ValidationBuilder().email().required().build(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted();
        }
      },
    );

Widget buildPassword({
  required TextEditingController passwordController,
  required FocusNode passwordFocusNode,
  final String? passwordLabelText,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      obscureText: true,
      focusNode: passwordFocusNode,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: passwordLabelText ?? 'Password',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
      ),
      validator: ValidationBuilder().minLength(8).required().build(),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted();
        }
      },
    );
