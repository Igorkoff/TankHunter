import 'package:flutter/material.dart';

Widget buildIconInfoCard({
  required context,
  required IconData icon,
  required String text,
}) =>
    Card(
      elevation: 2.5,
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

Widget buildInfoCard({
  required context,
  required String title,
  required String text,
  TextAlign? textAlign,
}) =>
    Card(
      elevation: 2.5,
      color: const Color(0xffE5EBFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            Text(
              title,
              maxLines: 1,
              textAlign: textAlign ?? TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20.0),
            Text(
              text,
              maxLines: 3,
              textAlign: textAlign ?? TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );

Widget buildSettingsCard({
  required context,
  required String title,
  required List rows,
  TextAlign? textAlign,
}) =>
    Card(
      elevation: 2.5,
      color: const Color(0xffE5EBFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            for (var row in rows) row,
          ],
        ),
      ),
    );
