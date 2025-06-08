// ReportDetails.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDetails extends StatefulWidget {
  final String userEmail;
  const ReportDetails({super.key, required this.userEmail});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = FirebaseFirestore.instance.collection('reports').doc(widget.userEmail).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No report found."));
          }

          final data = snapshot.data!.data()!;
          final heartRate = data['heartRate'] ?? '--';
          final bloodGroup = data['bloodGroup'] ?? '--';
          final weight = data['weight'] ?? '--';
          final doctorReport = data['doctorReport'] ?? 'No notes available.';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/44.jpg"),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.userEmail, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _infoBox("Heart Rate", "$heartRate bpm", Icons.monitor_heart, Colors.blue.shade300),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _infoBox("Blood Group", bloodGroup, Icons.bloodtype, Colors.red.shade100),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoBox("Weight", "$weight kg", Icons.monitor_weight, Colors.grey.shade300),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Latest Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.folder),
                    title: Text("Report"),
                    subtitle: Text("8 files"),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.analytics),
                    title: Text("Medical Analysis"),
                    subtitle: Text("8 files"),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Dr. Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    doctorReport,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoBox(String title, String value, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Icon(icon, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }
}
