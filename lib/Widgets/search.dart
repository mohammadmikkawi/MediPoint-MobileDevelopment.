import 'package:flutter/material.dart';
import 'package:training_1/Widgets/ProfileDoctorPage.dart';
import 'package:training_1/db/auth_search.dart';
import 'package:training_1/Widgets/ReportDetails.dart';
import 'package:training_1/Widgets/ChatPage.dart';
import 'package:training_1/Widgets/profileforP.dart';
import 'package:training_1/Widgets/homePage_P.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorsGridPage extends StatefulWidget {
  const DoctorsGridPage({super.key});

  @override
  State<DoctorsGridPage> createState() => _DoctorsGridPageState();
}

class _DoctorsGridPageState extends State<DoctorsGridPage> {
  final DoctorService _service = DoctorService();
  int _selectedIndex = 0;
  String name = 'Guest';
  String searchText = '';
  bool isGuest = true;
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final user = FirebaseAuth.instance.currentUser;

    final fetchedDoctors = await _service.fetchDoctors();

    if (user == null) {
      setState(() {
        name = 'Guest';
        isGuest = true;
        doctors = fetchedDoctors;
        filteredDoctors = fetchedDoctors;
      });
    } else {
      final fetchedName = await _service.fetchUserName();
      setState(() {
        name = fetchedName;
        isGuest = false;
        doctors = fetchedDoctors;
        filteredDoctors = fetchedDoctors;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0277BD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Doctors', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0277BD),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/Profile.png',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isGuest ? 'Hello Guest' : 'Hello Dr. $name',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.notifications_none,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'How Are You\nFeeling Today?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0288D1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  searchText = val.toLowerCase();
                                  filteredDoctors =
                                      doctors
                                          .where(
                                            (doc) => (doc['name'] ?? '')
                                                .toLowerCase()
                                                .contains(searchText),
                                          )
                                          .toList();
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                icon: Icon(Icons.search, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Spacer(),
                          Icon(Icons.filter_alt_outlined, size: 20),
                          SizedBox(width: 4),
                          Text("Filter"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: GridView.builder(
                        itemCount: filteredDoctors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.74,
                            ),
                        itemBuilder: (context, index) {
                          final doctor = filteredDoctors[index];
                          final String name = doctor['name'] ?? 'un';
                          final String imagePath =
                              doctor['image'] ?? 'assets/doctor.png';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DoctorProfilePage(
                                        uid: doctor['uid']!,
                                        imagePath: imagePath,
                                        isGuest: isGuest,
                                      ),
                                ),
                              );
                            },
                            child: DoctorCard(name: name, imagePath: imagePath),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0277BD),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Homepage_p()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ReportDetails(userEmail: 'NOORD2@gmail.com'),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ChatPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePageP()),
            );
          }
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
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const DoctorCard({super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC9CCCE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
