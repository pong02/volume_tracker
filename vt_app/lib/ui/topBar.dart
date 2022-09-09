import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/classes/options.dart';
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
      leading: const Icon(Icons.account_circle_rounded),
      title: Text(pageName),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (choice) {
            if (choice == Options.signout) {
              //invoke provider logout
              ref.read(loginControllerProvider.notifier).logout();
            } else if (choice == Options.settings) {
              print('Redir to settings screen');
              //push settings screen with back button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
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
}
