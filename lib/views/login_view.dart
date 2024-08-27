import 'package:app1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login Screen"),
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
                            .signInWithEmailAndPassword(
                                email: email, password: pwd);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print("user not found error");
                        } else if (e.code == 'wrong-password') {
                          print("password error");
                        }
                        print("firebaseAuth exception");
                        print(e.code);
                      } catch (e) {
                        print("some error occured" + e.toString());
                        print(e.runtimeType);
                      }
                    },
                    child: const Text("Login now"),
                  ),
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
