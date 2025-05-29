import 'package:firebase_auth/firebase_auth.dart';

Future<bool> loginUser(String email, String password) async {
  try {
    final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('✅ Login success for user: ${result.user?.email}');
    return true;
  } catch (e) {
    print('❌ Login error: $e');
    return false;
  }
}

