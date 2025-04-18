import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final Map<String, TextEditingController> controllers = {
    "Email" : TextEditingController(),
    "Password" : TextEditingController()
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalMargin = size.width/9.57;
    final textRatio = size.height/874;
    final unitItemSpace = size.height/43.7;
    return Scaffold(
      body: Column(
        children: [

          SizedBox(
            height: size.height * 0.20,
            width: double.infinity,
          ),

          Text(
            "Welcome Back",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25 * textRatio,
              fontFamily: 'Outfit'
            ),
          ),

          SizedBox(
            height: size.height/4.65,
            width: size.height/4.65,
            child: Image.asset("logo/logo-transparent.png"),
          ),

          Container(
            margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, top: size.height/70),
            decoration: BoxDecoration(
              color: const Color.fromARGB(85, 215, 215, 215),
              borderRadius: BorderRadius.circular(20)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextFormField(
              controller: controllers["Email"],
              cursorColor: Color.fromARGB(255, 62, 85, 97),
              decoration: InputDecoration(
                  icon: Icon(Icons.person,color: Color.fromARGB(255, 62, 85, 97)),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 62, 85, 97),
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 62, 85, 97),
                ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, top: unitItemSpace*2.1),
            decoration: BoxDecoration(
              color: const Color.fromARGB(85, 215, 215, 215),
              borderRadius: BorderRadius.circular(20)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextFormField(
              controller: controllers["Password"],
              cursorColor: Color.fromARGB(255, 62, 85, 97),
              decoration: InputDecoration(
                  icon: Icon(Icons.lock,color: Color.fromARGB(255, 62, 85, 97)),
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 62, 85, 97),
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 62, 85, 97),
                ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: unitItemSpace, left: 4*horizontalMargin),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  
                },
                child: Text(
                  "Forgot password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17 * textRatio,
                    fontFamily: 'Outfit'
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: unitItemSpace, left: horizontalMargin, right: horizontalMargin),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 62, 85, 97),
              ),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  print('UID: ${user.uid}');
                  print('Email: ${user.email}');
                  print('Created: ${user.metadata.creationTime}');
                  print('Last sign-in: ${user.metadata.lastSignInTime}');
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15 * textRatio),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textRatio * 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit'
                  ),
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 4 * unitItemSpace),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: textRatio * 17,
                    fontFamily: 'Outfit'
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/signup"
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17 * textRatio,
                        fontFamily: 'Outfit'
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}