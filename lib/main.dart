import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:training_1/Widgets/forgetpassword.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

 runApp(
  MaterialApp(
   home: WelcomPage(),
  ),
 );
}
