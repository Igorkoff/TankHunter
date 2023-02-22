import 'package:flutter/material.dart';

Widget buildAlertDialog({
  required context,
  required String title,
  required String message,
}) =>
    AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        )
      ],
      content: Text(
        message,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
