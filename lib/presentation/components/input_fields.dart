import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

Widget buildName({
  required context,
  required TextEditingController controller,
  final FocusNode? focusNode,
  final Color borderColor = const Color(0xff1D44A7),
  final String hintText = 'Example: Joseph',
  final TextStyle? hintStyle,
  final TextStyle? inputStyle,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      focusNode: focusNode,
      controller: controller,
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
      validator: ValidationBuilder().maxLength(35).required().build(),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted();
        }
      },
    );

Widget buildPassportNumber({
  required context,
  required TextEditingController controller,
  final FocusNode? focusNode,
  final Color borderColor = const Color(0xff1D44A7),
  final String hintText = 'Example: FF00000',
  final TextStyle? hintStyle,
  final TextStyle? inputStyle,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      focusNode: focusNode,
      controller: controller,
      textCapitalization: TextCapitalization.characters,
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
      validator: ValidationBuilder()
          .maxLength(9)
          .required()
          .regExp(RegExp(r'^(([A-Z]{2}\d{6})|(\d{9}))$'), 'Incorrect format of Passport Number')
          .build(),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted();
        }
      },
    );

Widget buildEmailAddress({
  required context,
  required TextEditingController controller,
  final FocusNode? focusNode,
  final Color borderColor = const Color(0xff1D44A7),
  final String hintText = 'example@mail.com',
  final TextStyle? hintStyle,
  final TextStyle? inputStyle,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      focusNode: focusNode,
      controller: controller,
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
  required TextEditingController controller,
  final FocusNode? focusNode,
  final Color borderColor = const Color(0xff1D44A7),
  final String hintText = 'password',
  final TextStyle? hintStyle,
  final TextStyle? inputStyle,
  final Function()? onSubmitted,
}) =>
    TextFormField(
      autocorrect: false,
      obscureText: true,
      focusNode: focusNode,
      controller: controller,
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
