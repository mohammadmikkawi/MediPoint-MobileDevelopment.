
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentManager {
  static final Map<DateTime, List<Map<String, String>>> _appointments = {};

  static void addAppointment(String name, DateTime date, String time) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    if (_appointments[normalizedDate] == null) {
      _appointments[normalizedDate] = [];
    }
    _appointments[normalizedDate]!.add({'name': name, 'time': time});
  }

  static List<Map<String, String>> getAppointmentsForDay(DateTime day) {
    final normalizedDate = DateTime.utc(day.year, day.month, day.day);
    return _appointments[normalizedDate] ?? [];
  }

  static Map<DateTime, List<Map<String, String>>> get allAppointments =>
      _appointments;
}

class Appointment {
  final String name;
  final String time;
  final DateTime dateTime;
  final String? id;
  final String? doctorName;
  final String? price;
  final String? email;
  final String? phone;

  Appointment({
    required this.name,
    required this.time,
    required this.dateTime,
    this.id,
    this.doctorName,
    this.price,
    this.email,
    this.phone,
  });
}

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late TabController _tabController;
  final ValueNotifier<List<Appointment>> _selectedEvents = ValueNotifier([]);

  // Theme colors
  final Color primaryColor = const Color(0xFF4A6FFF);
  final Color secondaryColor = const Color(0xFF6C63FF);
  final Color accentColor = const Color.fromARGB(255, 33, 29, 71);
  final Color backgroundColor = const Color(0xFFF8F9FF);
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF2D3142);
  final Color textSecondaryColor = const Color(0xFF9698A9);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _tabController = TabController(length: 2, vsync: this);
    _updateSelectedEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  void _updateSelectedEvents() {
    if (_selectedDay != null) {
      _getAcceptedAppointments().first.then((appointments) {
        _selectedEvents.value = _getAppointmentsForDay(_selectedDay!, appointments);
      });
    }
  }

  Stream<List<Appointment>> _getAcceptedAppointments() {
    return FirebaseFirestore.instance
        .collection('patients')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        DateTime appointmentDate;
        String appointmentTime;

        if (data['finalAppointmentDate'] != null) {
          if (data['finalAppointmentDate'] is Timestamp) {
            appointmentDate =
                (data['finalAppointmentDate'] as Timestamp).toDate();
          } else {
            appointmentDate = data['finalAppointmentDate'].toDate();
          }
          appointmentTime =
              data['finalAppointmentTime'] ??
                  data['appointmentTime'] ??
                  'Time not set';
        } else {
          try {
            final dateParts = (data['appointmentDate'] ?? '').split('-');
            if (dateParts.length == 3) {
              appointmentDate = DateTime(
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
                int.parse(dateParts[2]),
              );
            } else {
              appointmentDate = DateTime.now();
            }
          } catch (e) {
            appointmentDate = DateTime.now();
          }
          appointmentTime = data['appointmentTime'] ?? 'Time not set';
        }

        return Appointment(
          id: doc.id,
          name: data['name'] ?? 'Unknown Patient',
          time: appointmentTime,
          dateTime: appointmentDate,
          email: data['email'],
          phone: data['phone'],
        );
      }).toList();
    });
  }

  Future<Map<DateTime, List<Appointment>>> _getAllAppointments() async {
    final appointments = <DateTime, List<Appointment>>{};

    AppointmentManager.allAppointments.forEach((date, appointmentsList) {
      if (appointments[date] == null) {
        appointments[date] = [];
      }
      for (var appointment in appointmentsList) {
        appointments[date]!.add(
          Appointment(
            name: appointment['name']!,
            time: appointment['time']!,
            dateTime: date,
          ),
        );
      }
    });

    return appointments;
  }

  List<Appointment> _getAppointmentsForDay(
      DateTime day,
      List<Appointment> acceptedAppointments,
      ) {
    final normalizedDay = _normalizeDate(day);
    List<Appointment> dayAppointments = [];

    final managerAppointments = AppointmentManager.getAppointmentsForDay(day);
    for (var appointment in managerAppointments) {
      dayAppointments.add(
        Appointment(
          name: appointment['name']!,
          time: appointment['time']!,
          dateTime: normalizedDay,
        ),
      );
    }

    for (var appointment in acceptedAppointments) {
      final appointmentDay = _normalizeDate(appointment.dateTime);
      if (isSameDay(appointmentDay, normalizedDay)) {
        dayAppointments.add(appointment);
      }
    }

    dayAppointments.sort((a, b) => a.time.compareTo(b.time));

    return dayAppointments;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildAppBar(),

            _buildTabBar(),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCalendarView(),

                  _buildListView(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAppointmentDialog();
        },
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: textPrimaryColor,
                size: 18,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "Appointments",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color: primaryColor,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _updateSelectedEvents();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: primaryColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: textSecondaryColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: "Calendar"),
          Tab(text: "All Appointments"),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<List<Appointment>>(
        stream: _getAcceptedAppointments(),
        builder: (context, snapshot) {
          final acceptedAppointments = snapshot.data ?? [];

          return Column(
            children: [
              // Calendar Card
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TableCalendar<Appointment>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _updateSelectedEvents();
                    });
                  },
                  eventLoader: (day) {
                    return _getAppointmentsForDay(
                      day,
                      acceptedAppointments,
                    );
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                    markersAlignment: Alignment.bottomCenter,
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: textPrimaryColor),
                    holidayTextStyle: TextStyle(color: accentColor),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: primaryColor,
                      size: 28,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: primaryColor,
                      size: 28,
                    ),
                    headerPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ValueListenableBuilder<List<Appointment>>(
                  valueListenable: _selectedEvents,
                  builder: (context, appointments, _) {
                    if (_selectedDay == null) {
                      return _buildEmptyState("Select a day to view appointments");
                    }

                    if (appointments.isEmpty) {
                      return _buildEmptyState("No appointments for this day");
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDayHeader(),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              return _buildAppointmentCard(appointments[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<List<Appointment>>(
        stream: _getAcceptedAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          final appointments = snapshot.data ?? [];

          if (appointments.isEmpty) {
            return _buildEmptyState("No appointments scheduled");
          }

          final Map<String, List<Appointment>> groupedAppointments = {};

          for (var appointment in appointments) {
            final dateStr = DateFormat('yyyy-MM-dd').format(appointment.dateTime);
            if (!groupedAppointments.containsKey(dateStr)) {
              groupedAppointments[dateStr] = [];
            }
            groupedAppointments[dateStr]!.add(appointment);
          }

          final sortedDates = groupedAppointments.keys.toList()..sort();

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final dateStr = sortedDates[index];
              final dateAppointments = groupedAppointments[dateStr]!;
              final date = DateTime.parse(dateStr);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormat('MMM d').format(date),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('EEEE').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textPrimaryColor,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${dateAppointments.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...dateAppointments.map((appointment) => _buildAppointmentCard(appointment)).toList(),
                  if (index < sortedDates.length - 1)
                    Divider(color: Colors.grey.withOpacity(0.2)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDayHeader() {
    if (_selectedDay == null) return const SizedBox();

    return Row(
      children: [
        Text(
          'Appointments for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${_selectedEvents.value.length}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showAppointmentDetails(appointment);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment.time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      if (appointment.phone != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            appointment.phone!,
                            style: TextStyle(
                              fontSize: 14,
                              color: textSecondaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.phone,
                      color: Colors.green,
                      onTap: () {
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.message,
                      color: accentColor,
                      onTap: () {
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: textSecondaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: const Color.fromARGB(255, 30, 24, 55),
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading appointments',
            style: TextStyle(
              fontSize: 16,
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Appointment Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textSecondaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailItem(
              icon: Icons.person,
              title: 'Patient',
              value: appointment.name,
            ),
            _buildDetailItem(
              icon: Icons.calendar_today,
              title: 'Date',
              value: DateFormat('EEEE, MMMM d, yyyy').format(appointment.dateTime),
            ),
            _buildDetailItem(
              icon: Icons.access_time,
              title: 'Time',
              value: appointment.time,
            ),
            if (appointment.email != null)
              _buildDetailItem(
                icon: Icons.email,
                title: 'Email',
                value: appointment.email!,
              ),
            if (appointment.phone != null)
              _buildDetailItem(
                icon: Icons.phone,
                title: 'Phone',
                value: appointment.phone!,
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Reschedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 19, 46),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Appointment',
          style: TextStyle(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This feature will allow adding new appointments manually.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

