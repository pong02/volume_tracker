import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//This appears below the profile pic, and has many stats
//takes user as input so that is can stay stateless
class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return const Text("tis a card bruh");
    String checkmark = "";
    if (user.emailVerified) {
      checkmark = '\u{2713}';
    }
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Column(
            children: <Widget>[
              const ListTile(
                title: Text("Biography"),
                subtitle: Text(
                    "Precisely because we were born without any ability, we can achieve anything."),
              ),
              ListTile(
                title: const Text("Date joined"),
                subtitle: Text(user.uid),
              ),
              ListTile(
                //if verified, append checkmark
                title: Text(
                    String.fromCharCodes(Runes('Email Address $checkmark'))),
                subtitle: Text(user.email ?? "unknown"),
              ),
              ListTile(
                title: const Text("UUID"),
                subtitle: Text(user.uid),
              ),
            ],
          )),
    );
  }
}
