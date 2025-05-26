import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorService {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<String> fetchUserName() async {
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['name'] ?? 'User';
      }
    }
    return 'Guest';
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('doctors').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      data['image'] = _getImageForDoctor(doc.id);
      return data;
    }).toList();
  }

  String _getImageForDoctor(String uid) {
    switch (uid) {
      case '3pMrMp9z8TzUw4ZMzuiP':
        return 'assets/doctor.png';
      case 'r5phVyt9q4a6id074Obq':
        return 'assets/maher.png';
      case 'eWeb9T4AING9klEIoyQc':
        return 'assets/sara.png';
      case 'xsQxcafRukMoEcoDUMUp':
        return 'assets/abed.png';
      default:
        return 'assets/doctor.png';
    }
  }
}
