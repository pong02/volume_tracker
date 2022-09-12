import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email = "";
  final auth = FirebaseAuth.instance;
  late bool redir = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter an email' : null,
                  onChanged: (val) {
                    setState(() => _email = val.trim());
                  },
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  child: Text('Send Request'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String? msg;
                      try {
                        await auth.sendPasswordResetEmail(email: _email);
                      } on FirebaseException catch (e) {
                        print(e);
                        msg = e.message;
                      }
                      if (!mounted) {
                        return;
                      } //avoid buildcontext through async gaps error
                      summonDialog(context, msg);
                      if (redir) {
                        Navigator.of(context).pop();
                      }
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> summonDialog(BuildContext context, String? e) {
    String succTitle = "Email has been sent!";
    String succDetail = "Please be patient and check the spam folders as well!";

    String failTitle = "Error";
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: (e == null) ? Text(succTitle) : Text(failTitle),
        content: (e == null) ? Text(succDetail) : Text(e),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Return"),
          ),
        ],
      ),
    );
  }
}
