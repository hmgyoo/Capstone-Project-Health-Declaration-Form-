import 'package:capstone_proj/src/content/navigation/navbar.dart';
import 'package:capstone_proj/src/content/screens/homepage.dart';
import 'package:capstone_proj/src/login/screens/loginOrRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const BottomNavBar();
          }

          // user is not logged in
          else {
            return const LoginOrRegisterPage();
          }
        }),
      ),
    );
  }
}
