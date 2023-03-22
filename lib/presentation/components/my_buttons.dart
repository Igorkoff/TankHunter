import 'package:flutter/material.dart';

Widget buildIconButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: onClicked,
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
    );

Widget buildAppBarButton({
  required context,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    SizedBox(
      width: 40,
      height: 40,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: const Color(0xff01113A),
          elevation: 0.15,
          onPressed: onClicked,
          child: Icon(
            icon,
            color: const Color(0xffD6E1FE),
          ),
        ),
      ),
    );
