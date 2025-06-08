import 'package:flutter/material.dart';
import 'ChatDetailsPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 2;

  final List<Map<String, String>> doctors = [
    {
      'name': 'DR.Abdallah',
      'message': 'Good morning Does the patient have history?',
      'time': '10:50 PM',
      'image': 'https://randomuser.me/api/portraits/men/22.jpg'
    },
    {
      'name': 'DR.Ahmad',
      'message': 'Has the patient experienced any pain recently?',
      'time': '10:50 PM',
      'image': 'https://randomuser.me/api/portraits/men/35.jpg'
    },
    {
      'name': 'DR.Anas',
      'message': 'Please send me the latest blood test results.',
      'time': '10:50 PM',
      'image': 'https://randomuser.me/api/portraits/men/61.jpg'
    },
    {
      'name': 'DR.Amr',
      'message': 'We will need a second opinion on this case.',
      'time': '10:50 PM',
      'image': 'https://randomuser.me/api/portraits/men/47.jpg'
    },
    {
      'name': 'DR.Ameer',
      'message': 'Can we schedule the next follow-up tomorrow?',
      'time': '10:50 PM',
      'image': 'https://randomuser.me/api/portraits/men/52.jpg'
    },
    {
      'name': 'DR.Khaled',
      'message': 'Don’t forget to check the MRI scan.',
      'time': '10:50 PM',
      'image': 'https://randomuser.me/api/portraits/men/75.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chats', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const Divider(indent: 80, endIndent: 20, height: 0),
              itemBuilder: (context, index) {
                final doc = doctors[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailsPage(
                            name: doc['name']!,
                            image: doc['image']!,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(doc['image']!),
                    ),
                    title: Text(
                      doc['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        doc['message']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doc['time']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              // التنقل لصفحات أخرى عند الحاجة
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), label: 'Report'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
