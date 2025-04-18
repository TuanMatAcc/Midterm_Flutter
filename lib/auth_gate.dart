import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.from(alpha: 1, red: 62, green: 85, blue: 97),
            )
          ); // Loading
        }

        if (snapshot.hasData) {
          return HomePage(); // Replace with your home screen
        }

        return LoginPage();
      },
    );
  }
}