// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/providers/auth_provider.dart';
import 'package:volume_tracker/ui/deactivateScreen.dart';
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
  _SettingState();

  @override
  void initState() {
    super.initState();
  }

  String getDisplayName(WidgetRef ref) {
    User? user = ref.watch(authRepositoryProvider).getCurrentUser();
    return user!.email ?? "unknown";
  }

  Future<void> resetPW() async {
    final auth = FirebaseAuth.instance;
    final String email = getDisplayName(ref);
    String error = "";
    Navigator.pop(context);
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      error = e.message.toString();
    }
    if (!mounted) {
      return;
    }
    if (error.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email Sent!"),
        duration: Duration(seconds: 5),
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> verifyEmail() async {
    User? user = ref.watch(authRepositoryProvider).getCurrentUser();
    String error = "";
    try {
      if (user!.emailVerified) {
        error = "Account already verified!";
      } else if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseException catch (e) {
      error = e.message.toString();
    }
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
    if (error.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email Sent! Logging out."),
        duration: Duration(seconds: 5),
      ));
      Future.delayed(const Duration(seconds: 5), () {
        ref.read(loginControllerProvider.notifier).logout();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void logOutAux() {
    ref.read(loginControllerProvider.notifier).logout();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    late final String displayName = getDisplayName(ref);
    if (displayName.compareTo("unknown") == 0) {
      Navigator.pop(context);
    }
    return Scaffold(
        appBar:
            VAppBar(pageName: 'Settings', showMenu: false, showProfile: false),
        body: Center(
            child: Column(children: [
          const LocationToggle(),
          const ThemeToggle(),
          const NotificationToggle(),
          SettingOptionTile(
            name: "Deactivate Account",
            onTapRedir: const DeactivateScreen(),
          ), //confirm deactivation by reauth
          PopUpTile(
            // verify screen -> without prompt
            name: "Recover Account",
            yesOptionText: "OK",
            dialogTitle: "Send Recovery Email",
            dialogMsg:
                "Send reset email to $displayName? Please be sure to check under spam and be patient!",
            yesFunction: resetPW,
          ),
          SettingOptionTile(
              name:
                  "Report a bug"), //TODO: https://pub.dev/packages/flutter_email_sender -> redirect to emailapp
          PopUpTile(
            // verify screen -> without prompt
            name: "Verify Email",
            yesOptionText: "Verify",
            dialogTitle: "Verify your account?",
            dialogMsg:
                "Are you sure? Please be sure to check under spam and be patient!",
            yesFunction: verifyEmail,
          ),
          PopUpTile(
            name: "Logout",
            yesOptionText: "Log out",
            noOptionText: "Cancel",
            dialogTitle: "Are you sure you want to logout?",
            dialogMsg: "Logged in as $displayName",
            yesFunction: logOutAux,
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
  final void Function() yesFunction;

  PopUpTile(
      {Key? key,
      required this.name,
      this.tooltip = "",
      this.dialogTitle = "No title was given",
      this.dialogMsg = "No message was given",
      this.yesOptionText = "OK",
      this.noOptionText = "Cancel",
      required this.yesFunction})
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
                    onPressed: widget.yesFunction,
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
