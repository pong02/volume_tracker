// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/providers/auth_provider.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';
import 'package:volume_tracker/ui/vm/loginState.dart';

class DeactivateScreen extends StatefulHookConsumerWidget {
  const DeactivateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeactivateScreen> createState() => _DeactivateScreenState();
}

class _DeactivateScreenState extends ConsumerState<DeactivateScreen> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //listen to riverpod to show feedback on error
    ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));
    String email = ref.watch(authRepositoryProvider).getCurrentUser()!.email ??
        "undefined";
    return Scaffold(
      appBar: AppBar(title: const Text("Deactivate Account")),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'This action cannot be reverted and all data will be lost forever.',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                      child: const Text('Deactivate'),
                      onPressed: () async {
                        bool reauthSuccess = false;
                        FirebaseAuth auth = FirebaseAuth.instance;
                        User? user =
                            ref.read(authRepositoryProvider).getCurrentUser();
                        var credential = EmailAuthProvider.credential(
                            email: email, password: passwordController.text);
                        try {
                          await user!
                              .reauthenticateWithCredential(credential)
                              .then((value) => reauthSuccess = true);
                        } on FirebaseException catch (e) {
                          reauthSuccess = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message.toString())));
                        }
                        if (reauthSuccess) {
                          //success, final pop up confirmation, then logout after deactivating
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Final confirmation"),
                              content: const Text(
                                  "Are you sure? This is irreversible"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    user!.delete();
                                    if (!mounted) {
                                      return;
                                    }
                                    Navigator.pop(context);
                                    ref
                                        .read(loginControllerProvider.notifier)
                                        .logout();
                                    auth.signOut();
                                  },
                                  child: const Text("CONFIRM"),
                                ),
                              ],
                            ),
                          );
                        }
                      })),
            ],
          )),
    );
  }
}
