import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:training_1/Widgets/forgetpassword.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_1/Services//auth_provider.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

 runApp(
  MultiProvider(
   providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
   ],
   child: MaterialApp(
    home: WelcomPage(),
   ),
  ),
 );
}
