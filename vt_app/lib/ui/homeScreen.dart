// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';
import 'package:volume_tracker/ui/topBar.dart';
import 'package:volume_tracker/ui/botNavi.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: VAppBar(pageName: 'Home'),
        body: Center(
          child: Column(children: [
            const Text(
              "WELCOME TO HOME PAGE",
              style: AppTheme.defTextStyleTitle,
            ),
            ElevatedButton(
              child: const Text(
                'Sign out',
              ),
              onPressed: () {
                ref.read(loginControllerProvider.notifier).logout();
              },
            )
          ]),
        ),
        bottomNavigationBar: const CustomBottomNaviBar(),
        floatingActionButton: FloatingActionButton(onPressed: () => {},),
         floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,);
  }
}
