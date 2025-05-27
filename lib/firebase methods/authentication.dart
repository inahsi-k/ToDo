import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  

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
