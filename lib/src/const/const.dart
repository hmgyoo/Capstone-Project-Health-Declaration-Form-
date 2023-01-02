import 'package:flutter/material.dart';

// const variables for the projects

// colors
Color backgroundColor = Colors.grey.shade300;
Color primaryColor = Colors.blueGrey.shade500;
Color accentColor = Colors.yellow.shade800;

// screen size

// covid api color constants
Color kPrimaryColor = Color(0xFF166DE0);
Color kConfirmedColor = Color(0xFFFF1242);
Color kActiveColor = Color(0xFF017BFF);
Color kRecoveredColor = Color(0xFF29A746);
Color kDeathColor = Color(0xFF6D757D);

LinearGradient kGradientShimmer = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Colors.grey.shade300,
    Colors.grey.shade100,
  ],
);

RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]}.';
