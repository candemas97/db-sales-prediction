import 'package:firebase_auth/firebase_auth.dart';

class ValidUser {

  Future<bool> validUser(String emailAddress, String password) async {
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
        );
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
      return false;
  }

  Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();    
  } catch (e) {
    print('Error signing out: $e');    
  }
}



}