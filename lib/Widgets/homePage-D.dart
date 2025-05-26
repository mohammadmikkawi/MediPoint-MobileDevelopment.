import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homePage_D extends StatefulWidget {
  const homePage_D({super.key});

  @override
  State<homePage_D> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<homePage_D> {
  int _selectedIndex = 0;
  String name = 'Guest';

  @override
  void initState() {
    super.initState();
    fetchDoctorName();
  }

  Future<void> fetchDoctorName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
      if (doc.exists) {
        setState(() {
          name = doc.data()?['name'] ?? 'Guest';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),
            const SizedBox(height: 20),
            buildDoctorsRow(),
            const SizedBox(height: 20),
            buildMainImage(),
            const SizedBox(height: 20),
            buildInfoCards(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNav(),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0277BD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundImage: AssetImage('assets/Profile.png')),
          const SizedBox(width: 10),
          Text(
            'Hello Dr. $name',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none, color: Colors.black),
        ],
      ),
    );
  }

  Widget buildDoctorsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            "Doctor",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Text("See All", style: TextStyle(fontSize: 14)),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }

  Widget buildMainImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/doctors_image.jpg',
        ), // غيّر اسم الصورة حسب الموجود عندك
      ),
    );
  }

  Widget buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildInfoCard(Icons.monitor_weight, "Weight", "55kg"),
          buildInfoCard(Icons.height, "Height", "160cm"),
        ],
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0277BD),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_drive_file),
          label: 'Report',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
