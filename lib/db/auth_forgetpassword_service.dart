import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthServiceForgetPassword {
  String emailAuth;

  AuthServiceForgetPassword(this.emailAuth);

  void checke2() {
    print(emailAuth);
  }

  Future<bool> sendRestData() async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailAuth);
      return true;
    } catch (e) {
      print("Error to send");
      return false;
    }
  }
}
