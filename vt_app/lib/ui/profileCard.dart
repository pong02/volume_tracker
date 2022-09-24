import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//This appears below the profile pic, and has many stats
//takes user as input so that is can stay stateless
class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("tis a card bruh");
    //note that name form must be separate to avoid having state in this class
  }
}
