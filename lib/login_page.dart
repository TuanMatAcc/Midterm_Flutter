import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, TextEditingController> controllers = {
    "Email" : TextEditingController(),
    "Password" : TextEditingController()
  };

  final auth = FirebaseAuth.instance;

  String errorMessage = "";

  bool obscureText = true;

  void showSignUpFailureSnackBar(BuildContext context, {String errorMessage = 'Failed to create account'}) {
    final size = MediaQuery.of(context).size;
    final verticalRatio = size.height/874;
    final horizontalRatio = size.width/402;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12*horizontalRatio),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign-up Failed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16*verticalRatio,
                    ),
                  ),
                  SizedBox(height: 4*verticalRatio),
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 14*verticalRatio),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12*horizontalRatio, vertical: 12*verticalRatio),
        action: SnackBarAction(
          label: 'TRY AGAIN',
          textColor: Colors.white,
          onPressed: () {
            // Logic to retry or focus on the form
            // You could also dismiss the SnackBar here if needed
          },
        ),
      ),
    );
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    }
    on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found'
      || e.code == 'wrong-password'
      || e.code == 'invalid-email') {
        errorMessage = "Email or Password is wrong";
      }
      else if(e.code == 'user-disabled') {
        errorMessage = "Your account are banned by admin";
      }
      else {
        errorMessage = "Cannot login. Something went wrong !";
        print(e.message);
      }
      return null;
    } 
    catch(e) {
      return null;
    }
  }

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
              obscureText: obscureText,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock,color: Color.fromARGB(255, 62, 85, 97)),
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 62, 85, 97),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });

                    },
                    icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility)
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
              onPressed: () async {
                final user = await signIn(controllers["Email"]!.text, controllers["Password"]!.text);
                if(user == null) {
                  showSignUpFailureSnackBar(context, errorMessage: errorMessage);
                }
                else {
                  Navigator.pushNamed(context, "/home");
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