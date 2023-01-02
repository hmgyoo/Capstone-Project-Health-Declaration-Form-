import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../const/const.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      // show the current email of the user
      // wala munang edit profile for now, this the best i can sa ngayon
      // to follow nalang
      body: Center(
        child: Text('LOGGED IN AS: ${user?.email!}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ),
    );
  }
}
