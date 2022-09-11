import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';
import 'package:volume_tracker/ui/topBar.dart';
import 'package:volume_tracker/providers/setting_provider.dart';
import 'package:volume_tracker/ui/dummyRedir.dart';
import 'package:flutter/cupertino.dart';

//keep as hook consumer because might be used to update some providers (color mode, profile etc)
class SettingScreen extends StatefulHookConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatefulHookConsumerWidget> createState() => _SettingState();
}

class _SettingState extends ConsumerState<SettingScreen> {
  String displayName = "";
  _SettingState();
  late List<ToggleableOptionTile> _toggleCollection;

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

    //generate toggles
    _toggleCollection = [
      ToggleableOptionTile(
        name: "Notification",
        storageKey: "notification",
        streamProvider: notiStreamProvider,
        stateProvider: notiStateProvider,
      ),
      ToggleableOptionTile(
        name: "Location services",
        storageKey: "location",
        streamProvider: locStreamProvider,
        stateProvider: locStateProvider,
      ),
      ToggleableOptionTile(
        name: "Nightmode",
        storageKey: "nightmode",
        streamProvider: nightStreamProvider,
        stateProvider: nightStateProvider,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: VAppBar(pageName: 'Settings'),
        body: Center(
            child: Column(children: [
          _toggleCollection.elementAt(2),
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
    required this.name,
    this.tooltip = "",
    this.onTapRedir = const DummyRedir(),
  });

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
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ));
  }
}

class ToggleableOptionTile extends ConsumerStatefulWidget {
  final String name;
  final String tooltip;
  final AutoDisposeStreamProvider<bool> streamProvider;
  final StateProvider<Future<bool>> stateProvider;
  final String storageKey;

  ToggleableOptionTile({
    required this.name,
    this.tooltip = "",
    required this.streamProvider,
    required this.stateProvider,
    required this.storageKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ToggleableOptionTileState();
}

class _ToggleableOptionTileState extends ConsumerState<ToggleableOptionTile> {
  bool _switchedOn = false;

  void getFlag() {
    //get the configs from normal storage

    ref.read(widget.stateProvider.notifier).state.then((value) {
      print("${widget.name} init entry: $_switchedOn");
      _switchedOn = value;
      print("${widget.name} init complete: $_switchedOn");
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getFlag();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> pValue = localStorage.getBoolValuesSF(widget.storageKey);
    Future<bool> cValue;
    return ListTile(
      title: Text(widget.name),
      trailing: CupertinoSwitch(
        value: _switchedOn,
        onChanged: (bool value) {
          print("toggle (${widget.name}) pressed: $value");
          setState(() {
            _switchedOn = value;
          });
          localStorage.setBool(widget.storageKey,
              value); //update all providers +storage immediately
          cValue = localStorage.getBoolValuesSF(widget.storageKey);
          ref.refresh(widget.streamProvider);
          ref.refresh(widget.stateProvider.notifier);
          widget.stateProvider.updateShouldNotify(pValue, cValue);
          ref.read(widget.stateProvider.notifier).state.then((value) {
            print("postclick state: $value");
          });
        },
      ),
    );
  }
}

class PopUpTile extends StatefulWidget {
  final String name;
  final String tooltip;
  final String dialogTitle;
  final String dialogMsg;
  final String yesOptionText;
  final String noOptionText;

  PopUpTile(
      {required this.name,
      this.tooltip = "",
      this.dialogTitle = "No title was given",
      this.dialogMsg = "No message was given",
      this.yesOptionText = "OK",
      this.noOptionText = "Cancel"});

  @override
  _PopUpTileState createState() => _PopUpTileState();
}

class _PopUpTileState extends State<PopUpTile> {
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
                    onPressed: () =>
                        Navigator.pop(context, widget.yesOptionText),
                    child: Text(widget.yesOptionText),
                  ),
                ],
              ),
            ),
        child: ListTile(
          title: Text(widget.name),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ));
  }
}
