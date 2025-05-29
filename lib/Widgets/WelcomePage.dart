import 'package:flutter/material.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'package:training_1/Widgets/homePage-P.dart';
import 'package:training_1/Widgets/login.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Welcome! Are You Logging In As A Doctor Or A Patient?",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class WelcomPage extends StatelessWidget {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1979A9), Color(0xFFBBE8FF)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 70),
            Logo(400, 400),
            SizedBox(height: 40, width: 100),
            Introduction(),
            SizedBox(height: 50, width: 200),
            Flowbutton(Homepage_p(), "Patient", 40, 300),
            SizedBox(height: 20, width: 200),
            Flowbutton(Login(), "Doctor", 40, 300),
          ],
        ),
      ),
    );
  }
}
