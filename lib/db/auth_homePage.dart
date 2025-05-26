import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomepageDB {
  static Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Guest';

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    return doc.data()?['name'] ?? 'Guest';
  }

  static Future<List<Map<String, dynamic>>> fetchDoctors(
    List<String> orderedImages,
  ) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('doctors')
            .where('name', isGreaterThanOrEqualTo: 'Dr')
            .where('name', isLessThan: 'Ds')
            .get();

    return querySnapshot.docs.asMap().entries.map((entry) {
      final index = entry.key;
      final doc = entry.value;
      final data = doc.data();
      data['uid'] = doc.id;
      data['image'] =
          index < orderedImages.length
              ? orderedImages[index]
              : 'assets/doctor.png';
      return data;
    }).toList();
  }

  static List<Map<String, dynamic>> filterDoctors(
    List<Map<String, dynamic>> doctors,
    String query,
  ) {
    final lower = query.toLowerCase();
    if (query.isEmpty) return doctors;

    return doctors.where((doc) {
      final name = (doc['name'] ?? '').toString().toLowerCase();
      final nameWithoutPrefix = name.replaceFirst('dr.', '').trim();
      return name.contains(lower) || nameWithoutPrefix.contains(lower);
    }).toList();
  }
}
