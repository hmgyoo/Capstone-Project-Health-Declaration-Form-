import 'package:capstone_proj/src/const/const.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  // pass the function to navigate through different questions
  final VoidCallback nextQuestion;

  const NextButton({Key? key, required this.nextQuestion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: nextQuestion,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Text(
          'Next Question',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
