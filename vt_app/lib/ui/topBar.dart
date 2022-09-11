// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/classes/options.dart';
import 'package:volume_tracker/ui/profileScreen.dart';
import 'package:volume_tracker/ui/settingsScreen.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';

class VAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final String pageName;
  final double height;

  VAppBar({Key? key, required this.pageName, this.height = kToolbarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.account_circle_rounded),
        onPressed: () {
          _redirProfile(context, ref);
        },
      ),
      title: Text(pageName),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (choice) {
            if (choice == Options.signout) {
              //invoke provider logout
              ref.read(loginControllerProvider.notifier).logout();
              redirLogout(context);
            } else if (choice == Options.settings) {
              _redirSettings(context);
              //push settings screen with back button
            }
          },
          itemBuilder: (BuildContext context) {
            return Options.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

  void _redirProfile(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    User? user = await ref.read(loginControllerProvider.notifier).getUser();
    navigator.push(
        MaterialPageRoute(builder: (context) => ProfileScreen(profile: user)));
  }

  void _redirSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingScreen()),
    );
  }
}
