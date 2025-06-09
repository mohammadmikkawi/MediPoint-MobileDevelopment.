import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:training_1/db/auth_provider.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBCvkW9SXsftPiFkePDuj6XM29dzmpOhsU",
        authDomain: "midypoint-app.firebaseapp.com",
        projectId: "midypoint-app",
        storageBucket: "midypoint-app.firebasestorage.app",
        messagingSenderId: "368312545750",
        appId: "1:368312545750:web:5185dfb5cfdf8b438af477",
        measurementId: "G-CBERGVPSW4",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MidyPoint App',
      debugShowCheckedModeBanner: false,
      home: WelcomPage(),
    );
  }
}
