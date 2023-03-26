import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

Widget buildEmailAddress({
  required context,
  required TextEditingController emailAddressController,
  final FocusNode? emailAddressFocusNode,
  final Color borderColor = const Color(0xff1D44A7),
  final String hintText = 'example@mail.com',
  final TextStyle? hintStyle,
  final TextStyle? inputStyle,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      focusNode: emailAddressFocusNode,
      controller: emailAddressController,
      style: inputStyle ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyMedium,
        border:
            OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(16.0)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(16.0)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(16.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.5),
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
  required context,
  required TextEditingController passwordController,
  final FocusNode? passwordFocusNode,
  final Color borderColor = const Color(0xff1D44A7),
  final String hintText = 'password',
  final TextStyle? hintStyle,
  final TextStyle? inputStyle,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      obscureText: true,
      focusNode: passwordFocusNode,
      controller: passwordController,
      style: inputStyle ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyMedium,
        border:
            OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(16.0)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(16.0)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.circular(16.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.5),
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
