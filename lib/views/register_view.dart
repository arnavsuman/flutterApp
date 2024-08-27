
import 'package:app1/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    //creatre texteditingcontroller
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    //dispose texteditingcontroller
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // case ConnectionState.none:
            //   // TODO: Handle this case.
            // case ConnectionState.waiting:
            //   // TODO: Handle this case.
            // case ConnectionState.active:
            //   // TODO: Handle this case.
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "  Enter your emaild ID"),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: "  Enter your password"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      _email.clear();
                      final pwd = _password.text;
                      _password.clear();

                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: pwd);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print("weak password, use different password");
                        } else if (e.code == 'email-already-in-use') {
                          print("email already in use kindly Login ");
                        } else if (e.code == 'invalid-email') {
                          print("email format invalid");
                        } else {
                          print("caught exception");
                          print(e.code);
                        }
                      } catch (e) {
                        print("Some Exception occured");
                        print(e);
                      }
                    },
                    child: const Text("Register now"),
                  ),
                  TextButton(onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                  }, child: const Text("Already Registered? Sign IN here"),
                  )
                ],
              );
            default:
              return const Text("Loading....");
          }
        },
      ),
    );
  }
}
