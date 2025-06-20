import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_1/db/auth_doctor_profile_page.dart';

class DoctorProfilePage extends StatefulWidget {
  final String uid;
  final String imagePath;
  final bool isGuest;

  const DoctorProfilePage({
    super.key,
    required this.uid,
    required this.imagePath,
    required this.isGuest,
  });

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  Map<String, dynamic>? doctorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctorData(widget.uid).then((data) {
      if (data != null) {
        setState(() {
          doctorData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  child: DoctorProfileWidget(
                    doctorData: doctorData!,
                    imagePath: widget.imagePath,
                    currentDoctorUid: widget.uid,
                    isGuest: widget.isGuest,
                  ),
                ),
              ),
    );
  }
}

class DoctorProfileWidget extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  final String imagePath;
  final String currentDoctorUid;
  final bool isGuest;

  const DoctorProfileWidget({
    super.key,
    required this.doctorData,
    required this.imagePath,
    required this.currentDoctorUid,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final locationController = TextEditingController();
    final dateController = TextEditingController();

    return Column(
      children: [
        _buildTopBar(context),
        _buildDoctorCard(),
        const SizedBox(height: 40),
        _buildProfileTabs(),
        _buildAppointmentInfo(),
        const SizedBox(height: 30),
        isGuest
            ? _buildBookingButton(
              context,
              nameController,
              phoneController,
              emailController,
              locationController,
              dateController,
            )
            : const SizedBox(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          const Row(
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 10),
              Icon(Icons.share),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF145A86),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              doctorData['name'] ?? '',
              style: const TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 7, 7, 7),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _MiniInfoCard(icon: Icons.work_outline, label: '12 years'),
                _MiniInfoCard(icon: Icons.medical_services, label: 'Urology'),
                _MiniInfoCard(icon: Icons.groups, label: '50 +'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabs() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: TabBar(
              isScrollable: false,
              labelPadding: EdgeInsets.zero,
              indicator: BoxDecoration(
                color: const Color(0xFF145A86),
                borderRadius: BorderRadius.circular(20),
              ),
              unselectedLabelColor: Colors.black54,
              labelColor: Colors.white,
              tabs: const [
                Tab(
                  child: Center(
                    child: Text("About", style: TextStyle(fontSize: 13)),
                  ),
                ),
                Tab(
                  child: Center(
                    child: Text("Availability", style: TextStyle(fontSize: 13)),
                  ),
                ),
                Tab(
                  child: Center(
                    child: Text("Experience", style: TextStyle(fontSize: 13)),
                  ),
                ),
                Tab(
                  child: Center(
                    child: Text("Education", style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 120,
            child: TabBarView(
              children: [
                Text(doctorData['About'] ?? 'No information available.'),
                Text(doctorData['Availability'] ?? 'No information available.'),
                Text(doctorData['Experience'] ?? 'No information available.'),
                Text(doctorData['Education'] ?? 'No information available.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _InfoCard(title: "Price", value: doctorData['price'] ?? "N/A"),
          const SizedBox(width: 16),
          _InfoCard(title: "Time", value: doctorData['time'] ?? "N/A"),
        ],
      ),
    );
  }

  Widget _buildBookingButton(
    BuildContext context,
    TextEditingController name,
    TextEditingController phone,
    TextEditingController email,
    TextEditingController location,
    TextEditingController date,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Patient Information'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: name,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: phone,
                        decoration: const InputDecoration(labelText: 'Phone'),
                      ),
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: location,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      TextField(
                        controller: date,
                        decoration: const InputDecoration(labelText: 'Date'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await submitPatientBooking(
                        context: context,
                        doctorData: doctorData,
                        name: name.text,
                        phone: phone.text,
                        email: email.text,
                        location: location.text,
                        date: date.text,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF145A86),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniInfoCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
