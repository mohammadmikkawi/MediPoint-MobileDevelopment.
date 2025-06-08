
import 'package:flutter/material.dart';
import 'report_model.dart';
import 'report_controller.dart';

class EditReportPage extends StatefulWidget {
  final String userEmail;
  const EditReportPage({super.key, required this.userEmail});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController doctorReportController = TextEditingController();

  final ReportController _controller = ReportController();

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    final report = await _controller.fetchReport(widget.userEmail);
    if (report != null) {
      heartRateController.text = report.heartRate;
      bloodGroupController.text = report.bloodGroup;
      weightController.text = report.weight;
      doctorReportController.text = report.doctorReport;
    }
  }

  Future<void> _updateReport() async {
    final report = ReportModel(
      userEmail: widget.userEmail,
      heartRate: heartRateController.text,
      bloodGroup: bloodGroupController.text,
      weight: weightController.text,
      doctorReport: doctorReportController.text,
    );

    await _controller.updateReport(report);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Report Updated"),
        content: const Text("Medical report has been updated successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Medical Report"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildTextField("Heart Rate (bpm)", heartRateController),
            _buildTextField("Blood Group", bloodGroupController),
            _buildTextField("Weight (kg)", weightController),
            _buildTextField("Dr. Report", doctorReportController, maxLines: 4),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _updateReport,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
