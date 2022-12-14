// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/topBar.dart';
import 'package:volume_tracker/ui/botNavi.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: VAppBar(pageName: 'Plans'),
        body: Center(
          child: Column(children: [
            const Text(
              "WELCOME TO PLANS PAGE",
              style: AppTheme.defTextStyleTitle,
            )
          ]),
        ),
        bottomNavigationBar: const CustomBottomNaviBar(),
        floatingActionButton: FloatingActionButton(onPressed: () => {},),
         floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,);
  }
}
