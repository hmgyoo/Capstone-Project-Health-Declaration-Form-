import 'package:capstone_proj/src/const/const.dart';
import 'package:capstone_proj/src/login/services/authServices.dart';
import 'package:capstone_proj/src/login/utils/buttonUtil.dart';
import 'package:capstone_proj/src/login/utils/square_tile.dart';
import 'package:capstone_proj/src/login/utils/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  // onTap function
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // error message
  void errorMessage(String heading, String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(heading,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(
                          message,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // sign in user method w/ firebase
  void signUserUp() async {
    // loading circle while processing
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // when signing up
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        errorMessage(
            'Hold Up...',
            'The input password are not the same. Try again.',
            Colors.orange.shade600);
      }

      // pop the loading screen
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading screen
      Navigator.pop(context);

      // if the user types a wrong username
      if (e.code == 'user-not-found') {
        print('No user was found with this email.');
        // show error to user
        errorMessage('Uh oh...', 'You entered an incorrect email. Try again',
            Colors.red.shade600);
      }

      // if the user enters a wrong password
      else if (e.code == 'wrong-password') {
        print('Wrong password bruv');
        // show error to user
        errorMessage('Oh Snap!', 'You entered a wrong password. Try again',
            Colors.purple.shade600);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // use sizedbox for spacing between column items

              const SizedBox(height: 50),

              // logo
              Image.asset(
                'assets/images/Sign up-amico.png',
                width: 120,
              ),

              const SizedBox(height: 35),

              // welcome back to IHDPLM
              Text(
                'Create an account for IHDPLM.',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // username textfield
              MyTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true),

              const SizedBox(height: 10),

              // confirm password
              MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true),

              const SizedBox(height: 50),

              // sign up button
              MyButton(onTap: signUserUp, text: 'Sign Up'),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(
                      imagePath: 'assets/icons/google_logo.png',
                      onTap: () => AuthServices().signInWithGoogle()),

                  const SizedBox(width: 25),

                  //apple button
                  SquareTile(
                      imagePath: 'assets/icons/apple_logo.png',
                      onTap: () => AuthServices().signInWithGoogle()),
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login instead',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
