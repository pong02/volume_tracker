import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';
import 'package:volume_tracker/ui/topBar.dart';

//keep as hook consumer because might be used to update some providers (color mode, profile etc)
class SettingScreen extends HookConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: VAppBar(pageName: 'Settings'),
        body: Center(
          child: Column(children: [
            Text(
              "WELCOME TO setting PAGE",
              style: AppTheme.defTextStyleTitle,
            ),
            ElevatedButton(
              child: const Text(
                'Sign out',
              ),
              onPressed: () {
                ref.read(loginControllerProvider.notifier).logout();
                Navigator.pop(context);
              },
            )
          ]),
        ));
  }
}
