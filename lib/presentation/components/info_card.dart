import 'package:flutter/material.dart';

Widget buildInfoCard({
  required context,
  required IconData icon,
  required String text,
}) =>
    Card(
      elevation: 0.15,
      color: const Color(0xffE5EBFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 66.0, vertical: 22.0),
        child: Column(
          children: [
            Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14.0),
            Icon(icon, size: 30),
          ],
        ),
      ),
    );
