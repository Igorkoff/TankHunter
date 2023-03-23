import 'package:flutter/material.dart';

Widget buildSubmitButton({
  required context,
  required String title,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? foregroundColor,
  double? width,
  double? height,
}) =>
    ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2.5,
          shadowColor: const Color(0xff000000),
          backgroundColor: backgroundColor ?? const Color(0xffF5DB53),
          foregroundColor: foregroundColor ?? const Color(0xff01113A),
          fixedSize: Size(width ?? 170.0, height ?? 56.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          textStyle: Theme.of(context).textTheme.titleSmall,
        ),
        child: Text(title));

Widget buildAppBarButton({
  required context,
  required IconData icon,
  required VoidCallback onPressed,
}) =>
    SizedBox(
      width: 40,
      height: 40,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: const Color(0xff01113A),
          elevation: 0.15,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: const Color(0xffD6E1FE),
          ),
        ),
      ),
    );
