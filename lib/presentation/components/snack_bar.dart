import 'package:flutter/material.dart';

SnackBar buildSnackBar({
  required String messageText,
  required bool isError,
}) =>
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      duration: const Duration(seconds: 2),
      content: Text(messageText),
    );
