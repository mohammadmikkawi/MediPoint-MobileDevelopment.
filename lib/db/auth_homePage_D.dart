import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorHomeDB {
  static Future<String> fetchDoctorName() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) return 'Guest';

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!doc.exists) return 'Guest';

    return doc.data()?['name'] ?? 'Guest';
  }
}
