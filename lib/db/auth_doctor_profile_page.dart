import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> fetchDoctorData(String uid) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      data!['uid'] = uid;
      return data;
    }
  } catch (_) {
    return null;
  }
  return null;
}

Future<void> submitPatientBooking({
  required BuildContext context,
  required Map<String, dynamic> doctorData,
  required String name,
  required String phone,
  required String email,
  required String location,
  required String date,
}) async {
  try {
    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        location.isEmpty ||
        date.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final datePattern = RegExp(r'^\d{1,2}-\d{1,2}-\d{4}$');
    if (!datePattern.hasMatch(date.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter date in format DD-MM-YYYY')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final existing =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('userId', isEqualTo: user?.uid)
            .where('doctorId', isEqualTo: doctorData['uid'] ?? '')
            .where('appointmentDate', isEqualTo: date)
            .where('appointmentTime', isEqualTo: doctorData['time'] ?? '')
            .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking already exists')));
      return;
    }

    await FirebaseFirestore.instance.collection('patients').add({
      'userId': user?.uid,
      'doctorId': doctorData['uid'] ?? '',
      'doctorName': doctorData['name'] ?? '',
      'appointmentDate': date,
      'appointmentTime': doctorData['time'] ?? '',
      'price': doctorData['price'] ?? '',
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking Request Sent to Doctor')),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }
}

Future<String?> getUserRole() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return userDoc.data()?['role'] as String?;
}
