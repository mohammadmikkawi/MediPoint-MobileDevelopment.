import 'package:flutter/material.dart';
import 'package:training_1/db/auth_homePage-P.dart';
import 'package:training_1/Widgets/doctor_profile_page.dart';
import 'package:training_1/Widgets/search.dart';

class Homepage_p extends StatefulWidget {
  const Homepage_p({super.key});

  @override
  State<Homepage_p> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage_p> {
  int selectedIndex = -1;
  int _navIndex = 0;
  String name = 'User';
  bool isLoading = true;
  String searchText = '';
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];

  final List<String> orderedImages = [
    'assets/doctor.png',
    'assets/maher.png',
    'assets/sara.png',
    'assets/abed.png',
  ];

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final fetchedName = await HomepageDB.getUserName();
    final fetchedDoctors = await HomepageDB.fetchDoctors(orderedImages);
    setState(() {
      name = fetchedName;
      doctors = fetchedDoctors;
      filteredDoctors = fetchedDoctors;
      isLoading = false;
    });
  }

  void filterDoctors(String query) {
    setState(() {
      searchText = query;
      filteredDoctors = HomepageDB.filterDoctors(doctors, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildHeader(),
                      const SizedBox(height: 20),
                      buildDoctorSection(),
                      const SizedBox(height: 16),
                      buildBanner(),
                      const SizedBox(height: 10),
                      buildPageIndicators(),
                      const SizedBox(height: 20),
                      buildInfoCards(),
                      const SizedBox(height: 30),
                    ],
                  ),
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
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/Profile.png'),
              ),
              const SizedBox(width: 10),
              Text(
                'Hello Guest',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const Spacer(),
              const Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'How Are You\nFeeling Today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0288D1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              onChanged: filterDoctors,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for doctor...',
                icon: Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoctorList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: isSelected ? 250 : 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0277BD) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child:
                  isSelected
                      ? Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              doctor['image']!,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doctor['date'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              doctor['time'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          doctor['image']!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDoctorSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Doctors',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorsGridPage(),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Text('See All', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) {
              final doctor = filteredDoctors[index];
              return GestureDetector(
                onTap: () {
                  if (selectedIndex == index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DoctorProfilePage(
                              uid: doctor['uid'],
                              imagePath: doctor['image'],
                              name: name,
                            ),
                      ),
                    );
                  } else {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
                child: buildDoctorCard(
                  selected: selectedIndex == index,
                  imagePath: doctor['image'],
                  name: doctor['name'] ?? 'Dr.Aya',
                  date: doctor['date'] ?? '',
                  time: doctor['time'] ?? '12:00 PM',
                  showDetails: selectedIndex == index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/doctors.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPageIndicators() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 8, color: Colors.black54),
        SizedBox(width: 4),
        Icon(Icons.circle_outlined, size: 8, color: Colors.black26),
      ],
    );
  }

  Widget buildInfoCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        infoCard('Weight', '55kg', Icons.monitor_weight),
        infoCard('Height', '160cm', Icons.height),
      ],
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0277BD),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      currentIndex: _navIndex,
      onTap: (index) {
        setState(() {
          _navIndex = index;
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

  Widget buildDoctorCard({
    required bool selected,
    required String imagePath,
    required String name,
    required String date,
    required String time,
    required bool showDetails,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      width: showDetails ? 170 : 70,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0277BD) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child:
          showDetails
              ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(imagePath),
                    radius: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
    );
  }

  static Widget infoCard(String label, String value, IconData icon) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
