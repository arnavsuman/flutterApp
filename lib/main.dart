import 'package:app1/firebase_options.dart';
import 'package:app1/views/login_view.dart';
import 'package:app1/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 19, 74, 255)),
        useMaterial3: true,
      ),
      home: const LoginView(), //RegisterView(), //LoginView(), //HomePage()
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            print(user);

            if (user != null) {
              if (emailVerified) {
                print("Firebase Initialisation Done");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Text("Done");
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text("Please verify your email address"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              print(user);
            },
            child: const Text("Send Email Verification"),
          )
        ],
      ),
    );
  }
}
