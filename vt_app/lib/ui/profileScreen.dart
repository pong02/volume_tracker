// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:volume_tracker/ui/profileCard.dart';
import 'package:volume_tracker/ui/theme.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String pfpUrl = "";
  final TextEditingController _nameController = TextEditingController();

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

  void changeDisplayName() {
    String currentName = _nameController.text;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Change display name"),
        content: TextField(
          controller: _nameController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _nameController.text = currentName;
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.user.updateDisplayName(_nameController.text);
              setState(() {
                _nameController;
              });
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
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
    //update textcontroller to current name or guest
    _nameController.text = widget.user.displayName ?? "Guest";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Profile",
        )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //username space
              (Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Visibility(
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  visible: false,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit)),
                ),
                Flexible(child: Text(
                  _nameController.text,overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTheme.defTextStyleBig,
                )),
                IconButton(
                    onPressed: changeDisplayName, icon: const Icon(Icons.edit))
              ])),
              Center(
                  child: CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 58.0,
                  backgroundImage: pfpUrl.isEmpty
                      ? const AssetImage('assets/images/pfp-default.png')
                          as ImageProvider
                      : NetworkImage(pfpUrl),
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
              ProfileCard(user: widget.user),
            ]));
  }
}
