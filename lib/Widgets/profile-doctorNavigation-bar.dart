import 'package:flutter/material.dart';
import 'package:training_1/Widgets/ProfileforD.dart';
import 'package:training_1/Widgets/request-for-doctor.dart';
import 'package:training_1/Widgets/appointment-doctor.dart';
import 'package:training_1/Widgets/WelcomePage.dart';

class ProfileDoctorNavigationBar extends StatelessWidget {
  const ProfileDoctorNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
      routes: {
        '/request-for-doctor': (context) => const RequestsPage(),
        '/appointment-doctor': (context) => const AppointmentsPage(),
        '/welcome': (context) => WelcomPage(),

      },
    );
  }
}
