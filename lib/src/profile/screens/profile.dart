import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {

//   // define variables to be used
//   final _formKey = GlobalKey<FormState>();
//   final _firestore = FirebaseFirestore.instance;

//   late String _firstName;
//   late String _lastName;
//   late String _plmEmail;
//   late String _mobileNumber;
//   late String _studentId;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stream
//     );
//   }
// }