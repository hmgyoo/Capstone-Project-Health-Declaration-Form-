import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Google Sign in
  signInWithGoogle() async {
    // interactive design process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain the details from auth request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for the registered user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
