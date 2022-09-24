import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/ui/homeScreen.dart';
import 'package:volume_tracker/ui/theme.dart';
import 'package:volume_tracker/ui/vm/loginController.dart';
import 'package:volume_tracker/ui/vm/loginState.dart';

class Register extends ConsumerStatefulWidget {
  Register({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  bool confirmPW = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text('Sign up',
                      style: AppTheme.defTextStyleTitleColored)),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val.trim());
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (val) =>
                    val! != password ? 'Password is not the same!' : null,
                onChanged: (val) {
                  setState(() => confirmPW = (val == password));
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &
                        (confirmPW = true)) {
                      try {
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        ref
                            .read(loginControllerProvider.notifier)
                            .login(email, password);
                        LoginState state =
                            ref.read(loginControllerProvider.notifier).state;
                        if (!mounted) {
                          return;
                        }
                        if (state is LoginStateError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(state.error),
                          ));
                        } else {
                          _redirHome(context);
                        }
                      } on FirebaseException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.message.toString()),
                        ));
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

void _redirHome(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
