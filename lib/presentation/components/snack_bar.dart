import 'package:flutter/material.dart';

SnackBar buildSnackBar({
  required String messageText,
  required bool isError,
}) =>
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: isError ? const Duration(seconds: 3) : const Duration(seconds: 1),
      content: Text(messageText),
    );
