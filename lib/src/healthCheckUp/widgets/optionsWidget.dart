import 'package:capstone_proj/src/const/const.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  // pass the options
  final String option;

  // function for onTap
  final VoidCallback onTap;

  // change colors when clicked
  final Color color;

  const OptionWidget(
      {super.key,
      required this.option,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        child: ListTile(
          title: Text(
            option,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
