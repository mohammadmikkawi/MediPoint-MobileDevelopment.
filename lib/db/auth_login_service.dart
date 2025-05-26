import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthServiceLogin {
  String emailDB;
  String passwordDB;
  String key;

  AuthServiceLogin(this.emailDB, this.passwordDB, this.key);

  void checkDB() {
    print(emailDB);
    print(passwordDB);
    print(key);

    const doctorCode = "0000";
    if (key != doctorCode) {
      throw Exception("The key is not correct");
    } else {
      print("correct key");
    }
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
