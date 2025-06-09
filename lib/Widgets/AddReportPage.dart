import 'package:flutter/material.dart';
import 'report_controller.dart';
import 'report_model.dart';

class AddReportPage extends StatefulWidget {
  final String userEmail;
  const AddReportPage({super.key, required this.userEmail});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController doctorReportController = TextEditingController();

  final ReportController _controller = ReportController();

  Future<void> _saveReport() async {
    final report = ReportModel(
      userEmail: widget.userEmail,
      heartRate: heartRateController.text,
      bloodGroup: bloodGroupController.text,
      weight: weightController.text,
      doctorReport: doctorReportController.text,
    );

    await _controller.saveReport(report);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Report Saved"),
        content: const Text("Medical report has been added successfully."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Medical Report"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildTextField("Heart Rate (bpm)", heartRateController),
            const SizedBox(height: 16),
            _buildTextField("Blood Group", bloodGroupController),
            const SizedBox(height: 16),
            _buildTextField("Weight (kg)", weightController),
            const SizedBox(height: 16),
            _buildTextField("Dr. Report", doctorReportController, maxLines: 4),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveReport,
              icon: const Icon(Icons.save),
              label: const Text("Save Report"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      maxLines: maxLines,
      keyboardType: label.contains("bpm") || label.contains("kg")
          ? TextInputType.number
          : TextInputType.text,
    );
  }
}
