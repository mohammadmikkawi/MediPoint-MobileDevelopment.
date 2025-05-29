import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:training_1/Widgets/forgetpassword.dart';
import 'package:training_1/Widgets/homePage-P.dart';
import 'package:training_1/Widgets/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomPage(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/forget': (context) => Forgetpassword(),
        '/homeD': (context) => Homepage_p(),
        '/search': (context) => DoctorsGridPage(),
      },
    );
  }
}
