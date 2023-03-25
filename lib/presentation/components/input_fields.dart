import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

Widget buildEmailAddress({
  required context,
  required TextEditingController emailAddressController,
  final FocusNode? emailAddressFocusNode,
  final String? hintText,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      focusNode: emailAddressFocusNode,
      controller: emailAddressController,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText ?? 'example@mail.com',
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
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
  final Function()? onSubmitted,
  final String? hintText,
}) =>
    TextFormField(
      obscureText: true,
      focusNode: passwordFocusNode,
      controller: passwordController,
      decoration: InputDecoration(
        hintText: hintText ?? 'password',
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1D44A7)), borderRadius: BorderRadius.circular(16.0)),
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
