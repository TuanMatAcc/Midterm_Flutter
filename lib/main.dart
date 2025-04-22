import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:midterm/auth_gate.dart';
import 'package:midterm/home_page.dart';
import 'package:midterm/login_page.dart';
import 'package:midterm/signup_page.dart';

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
      title: "TechThink",
      initialRoute: "/",
      routes: {
        "/" : (context) => AuthGate(),
        "/login" : (context) => LoginPage(),
        "/signup" : (context) => SignUpPage(),
        "/home" : (context) => HomePage(),
      },
    );
  }
}

