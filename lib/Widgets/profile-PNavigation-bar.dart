import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:training_1/Widgets/ProfileforP.dart';
import 'package:training_1/Widgets/appointment-P.dart';
import 'package:training_1/Widgets/WelcomePage.dart';

class PatientProfileNavigationBar extends StatelessWidget {
  const PatientProfileNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePageP(),
      routes: {
        '/appointment-doctor': (context) => const AppointmentsPageD(),
        '/welcome': (context) => WelcomPage(),
      },
    );
  }
}
