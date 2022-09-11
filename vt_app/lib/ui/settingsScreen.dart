// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';
import 'package:volume_tracker/ui/topBar.dart';
import 'package:volume_tracker/ui/dummyRedir.dart';
import 'package:volume_tracker/ui/toggleTiles.dart';

//keep as hook consumer because might be used to update some providers (color mode, profile etc)
class SettingScreen extends StatefulHookConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatefulHookConsumerWidget> createState() => _SettingState();
}

class _SettingState extends ConsumerState<SettingScreen> {
  String displayName = "";
  _SettingState();

  @override
  void initState() {
    super.initState();
    //get ? from secure storage
    // context.read(userNameProvider).state.then((value) {
    //   if (value != null) {
    //     setState(() {
    //       displayName = value;
    //     });
    //   }
    // }); //settle because value not immediately built
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: VAppBar(pageName: 'Settings'),
        body: Center(
            child: Column(children: [
          const LocationToggle(),
          const ThemeToggle(),
          const NotificationToggle(),
          SettingOptionTile(name: "Deactivate Account"),
          SettingOptionTile(name: "Recover Account"),
          SettingOptionTile(name: "Report a bug"),
          PopUpTile(
            name: "Logout",
            yesOptionText: "Log out",
            noOptionText: "Cancel",
            dialogTitle: "Are you sure you want to logout?",
            dialogMsg: "Logged in as $displayName",
          )
        ])));
  }
}

class SettingOptionTile extends StatefulWidget {
  final String name;
  final String tooltip;
  final Widget onTapRedir;

  SettingOptionTile({
    Key? key,
    required this.name,
    this.tooltip = "",
    this.onTapRedir = const DummyRedir(),
  }) : super(key: key);

  @override
  _SettingOptionTileState createState() => _SettingOptionTileState();
}

class _SettingOptionTileState extends State<SettingOptionTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return widget.onTapRedir;
              },
            )),
        child: ListTile(
          title: Text(widget.name),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ));
  }
}

class PopUpTile extends ConsumerStatefulWidget {
  final String name;
  final String tooltip;
  final String dialogTitle;
  final String dialogMsg;
  final String yesOptionText;
  final String noOptionText;

  PopUpTile(
      {Key? key,
      required this.name,
      this.tooltip = "",
      this.dialogTitle = "No title was given",
      this.dialogMsg = "No message was given",
      this.yesOptionText = "OK",
      this.noOptionText = "Cancel"})
      : super(key: key);

  @override
  _PopUpTileState createState() => _PopUpTileState();
}

class _PopUpTileState extends ConsumerState<PopUpTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(widget.dialogTitle),
                content: Text(widget.dialogMsg),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, widget.noOptionText),
                    child: Text(widget.noOptionText),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(loginControllerProvider.notifier).logout();
                      redirLogout(context);
                      Navigator.pop(context, widget.yesOptionText);
                    },
                    child: Text(widget.yesOptionText),
                  ),
                ],
              ),
            ),
        child: ListTile(
          title: Text(widget.name),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
        ));
  }
}
