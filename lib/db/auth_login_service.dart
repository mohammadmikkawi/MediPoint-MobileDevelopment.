import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthServiceLogin {
  String emailDB;
  String passwordDB;

  AuthServiceLogin(this.emailDB, this.passwordDB);

  void checkDB() {
    print(emailDB);
    print(passwordDB);
  }

  Future<bool> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailDB,
        password: passwordDB,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
