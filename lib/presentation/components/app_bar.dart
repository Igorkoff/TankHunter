import 'package:flutter/material.dart';
import 'package:tank_hunter/presentation/pages/tips_page.dart';
import 'buttons.dart';

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
                heroTag: null,
                icon: leftButtonIcon ?? Icons.menu_outlined,
                onPressed: leftButtonFunction ?? () => Scaffold.of(context).openDrawer(),
              ),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              buildAppBarButton(
                context: context,
                heroTag: null,
                icon: rightButtonIcon ?? Icons.info_outline,
                onPressed: rightButtonFunction ??
                    () => Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const TipsPage(),
                          ),
                        ),
              ),
            ],
          ),
          subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodyMedium) : Container(),
        ],
      ),
    );
