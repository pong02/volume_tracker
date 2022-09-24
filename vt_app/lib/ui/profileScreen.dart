// ignore_for_file: file_names

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String pfpUrl = "";

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 100,
    );

    if (image != null) {
      //fixing the ref here to only be editing pfp.jpg for user
      Reference fbRef = FirebaseStorage.instance
          .ref()
          .child("/users/${widget.user.uid}/pfp.jpg");

      await fbRef.putFile(File(image.path));
      fbRef.getDownloadURL().then((imgUrl) {
        //print(imgUrl);
        setState(() {
          pfpUrl = imgUrl;
        });
      });
    }
  }

  void updatePfp() {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("/users/${widget.user.uid}/pfp.jpg");

    ref.getDownloadURL().catchError((err) {
      print('Download Error: $err');
      return "";
    }).then((imgUrl) {
      if (!mounted) {
        return;
      }
      setState(() {
        pfpUrl = imgUrl;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (pfpUrl.isEmpty) {
      //update pfp here, but only if empty
      updatePfp();
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: add a form to set displayname?
    //TODO: add a profileCard to show random stuff.
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Column(children: [
          Text("this is ur profile page btw ${widget.user.displayName}"),
          Center(
              child: CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 58.0,
              backgroundImage: pfpUrl.isEmpty
                  ? const AssetImage('assets/images/pfp-default.png')
                      as ImageProvider
                  : NetworkImage(pfpUrl), //Image.network(pfpUrl),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                          onTap: pickUploadImage,
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/pencil.png'),
                            radius: 11.0,
                          )))),
            ),
          )),
        ]));
  }
}
