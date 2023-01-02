import 'package:flutter/material.dart';
import '../../const/const.dart';

// dialog widget to show when the form is done
class ResultBox extends StatelessWidget {
  // on pressed function
  final VoidCallback onPressed;

  const ResultBox({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      content: Padding(
        padding: const EdgeInsets.all(40),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thank you for answering the form. Let us continue helping the school fight against the pandemic.',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),

              //start over button
              GestureDetector(
                onTap: () {
                  // function to start over will be passed on from header form
                  onPressed;
                },
                child: Text(
                  'Back to start',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
