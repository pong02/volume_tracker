// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final User? profile;
  const ProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? name = profile!.displayName;
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Text("this is ur profile page btw $name"));
  }
}
