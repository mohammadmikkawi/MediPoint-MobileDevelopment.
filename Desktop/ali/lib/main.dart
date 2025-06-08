// main.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatPage.dart';
import 'AddReportPage.dart';
import 'ReportDetails.dart';
import 'EditReportPage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: ReportPage(),
    );
  }
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _selectedIndex = 1;
  final List<Map<String, String>> users = [
    {
      'name': 'Noor Ali',
      'email': 'NOORD2@gmail.com',
      'image': 'https://randomuser.me/api/portraits/men/44.jpg'
    },
    {
      'name': 'Ali khaled',
      'email': 'ali.khaled@gmail.com',
      'image': 'https://i.pravatar.cc/150?img=2'
    },
    {
      'name': 'Ahmad Salah',
      'email': 'ahmad.s@gmail.com',
      'image': 'https://randomuser.me/api/portraits/men/22.jpg'
    },
    {
      'name': 'Saif Khatib',
      'email': 'saif.khatib@gmail.com',
      'image': 'https://i.pravatar.cc/150?img=4'
    },
  ];

  Map<String, bool> reportStatus = {};

  @override
  void initState() {
    super.initState();
    _loadReportsStatus();
  }

  Future<void> _loadReportsStatus() async {
    final statusMap = <String, bool>{};
    for (var user in users) {
      final email = user['email']!;
      final doc = await FirebaseFirestore.instance.collection('reports').doc(email).get();
      statusMap[email] = doc.exists;
    }
    setState(() {
      reportStatus = statusMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {},
        ),
        title: Text('Report', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final email = user['email']!;

          if (!reportStatus.containsKey(email)) {
            return const Center(child: CircularProgressIndicator());
          }

          final reportExists = reportStatus[email]!;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user['image']!),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(email, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                reportExists
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditReportPage(userEmail: email),
                          ),
                        ).then((_) => _loadReportsStatus());
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportDetails(userEmail: email),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('View'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('reports')
                            .doc(email)
                            .delete();
                        _loadReportsStatus();
                      },
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                )
                    : Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddReportPage(userEmail: email),
                        ),
                      ).then((_) => _loadReportsStatus());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
