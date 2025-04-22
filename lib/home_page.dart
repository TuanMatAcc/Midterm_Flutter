import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Object/app_user.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Future<String> callHelloUser({required Map<String, dynamic> user}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('helloUser');
    final result = await callable.call(user);
    return result.data;
  }

  Future<AppUser?> fetchUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get();

      if(docSnapshot.exists) {
        final data = docSnapshot.data();
        return AppUser(
          email: data?['email'],
          fullName: data?['fullName'],
          shippingAddress: data?['shippingAddress'],
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<AppUser?>(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(!snapshot.hasData) {
            return const Center(child: Text("No user data found"),);
          }

          final appUser = snapshot.data;

          if(appUser != null) {
            final userMap = {
              "email" : appUser.email,
              "fullName" : appUser.fullName,
              "loyaltyPoints" : appUser.loyaltyPoints,
              "shippingAddress" : appUser.shippingAddress,
            };
            print(userMap["fullName"]);
            return FutureBuilder(
              future: callHelloUser(user: userMap),
              builder: (context, snapshot) => Center(
                child: Text(snapshot.data ?? "Who Are You ?", style: TextStyle(fontSize: 30),),
              ),
            );
          } 
          return Center(
            child: Text("This is my bug ! Not your fault"),
          );
        }
      ),
    );
  }
}