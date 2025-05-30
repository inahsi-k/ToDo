import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
   
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return 'Cancelled by user';
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }


  Future<String> signup({
    required String email,
    required String password,
  }) async {
    String res;
    try {
      res = "Some error occurred";
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'Success';
      } else {
        res = "Please fill all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res;
    try {
      res = "Some error occurred";
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
      } else {
        res = "Please fill all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> resetPassword({required email}) async {
    String res;
    try {
      res = "some error occurred";
      if (email.isNotEmpty) {
        await auth.sendPasswordResetEmail(email: email);
        res = "Success";
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.toString();
    }
    return res;
  }
}
