import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentManager {
  static final Map<DateTime, List<Map<String, String>>> _appointments = {};

  static void addAppointment(String name, DateTime date, String time) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    if (_appointments[normalizedDate] == null) {
      _appointments[normalizedDate] = [];
    }
    _appointments[normalizedDate]!.add({'name': name, 'time': time});
  }

  static Map<DateTime, List<Map<String, String>>> get allAppointments =>
      _appointments;
}

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFE5E5EA),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Booking Requests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFE5E5EA),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => _selectDate(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (selectedDate != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.blue[700], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Filtered by: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = null;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.blue[700],
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getBookingsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    print('Firestore error: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 64, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading bookings',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            selectedDate != null
                                ? 'No bookings for selected date'
                                : 'No pending bookings',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'New booking requests will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return BookingRequestTile(
                        patientName: data['name'] ?? 'Unknown Patient',
                        appointmentTime: data['appointmentTime'] ?? 'No time',
                        timestamp: formatTimestamp(data['timestamp']),
                        requestId: doc.id,
                        onAccept: () => _showAppointmentDialog(
                          context,
                          doc.id,
                          data['doctorName'] ?? 'Unknown',
                          data,
                        ),
                        onDecline: () => updateBookingStatus(
                          context,
                          doc.id,
                          'declined',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getBookingsStream() {
    try {
      if (selectedDate != null) {
        final dateString =
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
        return FirebaseFirestore.instance
            .collection('patients')
            .where('status', isEqualTo: 'pending')
            .where('appointmentDate', isEqualTo: dateString)
            .snapshots();
      } else {
        return FirebaseFirestore.instance
            .collection('patients')
            .where('status', isEqualTo: 'pending')
            .snapshots();
      }
    } catch (e) {
      print('Error in _getBookingsStream: $e');
      return const Stream.empty();
    }
  }

  String formatTimestamp(dynamic timestampField) {
    try {
      if (timestampField == null) return 'No timestamp';

      DateTime dt;
      if (timestampField is Timestamp) {
        dt = timestampField.toDate().toLocal();
      } else if (timestampField is String) {
        dt = DateTime.parse(timestampField).toLocal();
      } else {
        return 'Invalid timestamp';
      }

      final now = DateTime.now();
      final difference = now.difference(dt);

      if (difference.inDays == 0) {
        if (difference.inHours > 0) {
          return '${difference.inHours}h ${difference.inMinutes % 60}m ago';
        } else if (difference.inMinutes > 0) {
          return '${difference.inMinutes}m ago';
        } else {
          return 'Just now';
        }
      } else if (difference.inDays == 1) {
        return 'Yesterday at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Invalid timestamp';
    }
  }

  void updateBookingStatus(
      BuildContext context,
      String bookingId,
      String newStatus,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(bookingId)
          .update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking ${newStatus == 'accepted' ? 'accepted' : 'declined'}',
          ),
          backgroundColor: newStatus == 'accepted' ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showAppointmentDialog(
      BuildContext context,
      String bookingId,
      String doctorName,
      Map<String, dynamic> bookingData,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppointmentDialog(
          doctorName: doctorName,
          bookingData: bookingData,
          onConfirm: (DateTime selectedDate, String selectedTime) async {
            try {
              await FirebaseFirestore.instance
                  .collection('patients')
                  .doc(bookingId)
                  .update({
                'status': 'accepted',
                'finalAppointmentDate': selectedDate,
                'finalAppointmentTime': selectedTime,
                'acceptedAt': FieldValue.serverTimestamp(),
              });

              AppointmentManager.addAppointment(
                doctorName,
                selectedDate,
                selectedTime,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Booking for Dr. $doctorName accepted and appointment scheduled',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );

            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class BookingRequestTile extends StatelessWidget {
  final String patientName;
  final String appointmentTime;
  final String timestamp;
  final String requestId;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const BookingRequestTile({
    super.key,
    required this.patientName,
    required this.appointmentTime,
    required this.timestamp,
    required this.requestId,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF007AFF),
      const Color(0xFF34C759),
      const Color(0xFFFF9500),
      const Color(0xFFFF3B30),
      const Color(0xFF5856D6),
      const Color(0xFFAF52DE),
    ];
    final colorIndex = patientName.hashCode % colors.length;
    final avatarColor = colors[colorIndex.abs()];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: avatarColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    patientName.isNotEmpty ? patientName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Requested $timestamp',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  appointmentTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextButton(
                    onPressed: onAccept,
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextButton(
                    onPressed: onDecline,
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: const Text(
                      'Decline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  


class AppointmentDialog extends StatefulWidget {
  final String doctorName;
  final Map<String, dynamic> bookingData;
  final Function(DateTime, String) onConfirm;

  const AppointmentDialog({
    super.key,
    required this.doctorName,
    required this.bookingData,
    required this.onConfirm,
  });

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '08:00';

  @override
  void initState() {
    super.initState();
    if (widget.bookingData['appointmentDate'] != null) {
      try {
        final dateParts = widget.bookingData['appointmentDate'].split('/');
        if (dateParts.length == 3) {
          selectedDate = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
          );
        }
      } catch (e) {
      }
    }

    if (widget.bookingData['appointmentTime'] != null) {
      selectedTime = widget.bookingData['appointmentTime'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Do you accept the appointment with the patient?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient\'s Request:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${widget.bookingData['appointmentDate']}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Time: ${widget.bookingData['appointmentTime']}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Price: \$${widget.bookingData['price']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: Text("${selectedDate.toLocal()}".split(' ')[0]),
            subtitle: const Text('Tap to change final appointment date'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(selectedTime),
            subtitle: const Text('Tap to change final appointment time'),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  selectedTime = time.format(context);
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Confirm Appointment'),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onConfirm(selectedDate, selectedTime);
          },
        ),
      ],
    );
  }
}



