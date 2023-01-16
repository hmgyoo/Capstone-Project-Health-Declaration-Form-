import 'package:capstone_proj/src/const/const.dart';
import 'package:capstone_proj/src/content/screens/countriesPage.dart';
import 'package:capstone_proj/src/content/screens/homepage.dart';
import 'package:capstone_proj/src/healthCheckUp/screens/headerForm.dart';
import 'package:capstone_proj/src/reminders/screens/sendReminders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../profile/screens/profile.dart';
import '../../reminders/screens/notificatons.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // user instance
  final user = FirebaseAuth.instance.currentUser!;

  // sign out user
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // selected index for default nav
  int _selectedIndex = 0;

  // list of screens
  final List<Widget> _tabs = <Widget>[
    const HomePage(),
    const CountryPage(),
    const HeaderForm(),
    const SendRemindersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // get relative size of screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
        backgroundColor: primaryColor,
        title: const Text('Health Declaration App - PLM'),
        centerTitle: true,
        elevation: 0,
      ),

      // decorate the body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),

              // change screens depending on the tapped bar
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _tabs[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          // color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GNav(
              haptic: true,
              duration: const Duration(milliseconds: 400),
              // backgroundColor: primaryColor,
              color: Colors.grey.shade500,
              activeColor: primaryColor,
              // tabBackgroundColor: Colors.blueGrey.shade400,
              gap: 8,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(icon: Icons.home, text: 'Summary'),
                GButton(icon: Icons.map, text: 'Regions'),
                GButton(icon: Icons.note, text: 'Check-in'),
                GButton(icon: Icons.calendar_month, text: 'Reminder'),
                GButton(icon: Icons.person, text: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
