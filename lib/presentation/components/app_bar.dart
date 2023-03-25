import 'package:flutter/material.dart';
import 'my_buttons.dart';

Widget buildAppBar({
  required context,
  required String title,
  String? subtitle,
  IconData? leftButtonIcon,
  VoidCallback? leftButtonFunction,
  IconData? rightButtonIcon,
  VoidCallback? rightButtonFunction,
}) =>
    Container(
      margin: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildAppBarButton(
                context: context,
                heroTag: 'left_button',
                icon: leftButtonIcon ?? Icons.menu_outlined,
                onPressed: leftButtonFunction ?? () => Scaffold.of(context).openDrawer(),
              ),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              buildAppBarButton(
                context: context,
                heroTag: 'right_button',
                icon: rightButtonIcon ?? Icons.info_outline,
                onPressed: rightButtonFunction ?? () {},
              ),
            ],
          ),
          subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodyMedium) : Container(),
        ],
      ),
    );
