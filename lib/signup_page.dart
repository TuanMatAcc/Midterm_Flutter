import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Object/app_user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Map<String, TextEditingController> controllers = {
    "Name" : TextEditingController(),
    "Email" : TextEditingController(),
    "Address" : TextEditingController(),
    "Password" : TextEditingController()
  };
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  String errorMessage = "";
  bool isEmailFormatError = false;
  bool isExistingEmail = false;

  AppUser createAppUser({required String email, required String fullName, required String shippingAddress, loyaltyPoints}) {
    return AppUser(
      email: email,
      fullName: fullName, 
      shippingAddress: shippingAddress
    );
  }

  Future<void> saveUserInformation({required AppUser user}) async {
    final userDoc = FirebaseFirestore.instance.collection("Users").doc(user.email);

    await userDoc.set({
      'email' : user.email,
      'fullName' : user.fullName,
      'shippingAddress' : user.shippingAddress,
      'loyaltyPoints' : user.loyaltyPoints
    });
  }

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

  void showSuccessSnackBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalRatio = size.height/874;
    final horizontalRatio = size.width/402;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12*horizontalRatio),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Success!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16*verticalRatio,
                      fontFamily: 'Outfit'
                    ),
                  ),
                  SizedBox(height: 4*verticalRatio),
                  Text(
                    'Your account has been created successfully',
                    style: TextStyle(
                      fontSize: 14*verticalRatio,
                      fontFamily: 'Outfit'
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 7, 92, 11),
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12*horizontalRatio, vertical: 12*verticalRatio),
      ),
    );
  }

  Future<bool> signUp() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: controllers["Email"]!.text,
        password: controllers["Password"]!.text
      );
      return true;
    }
    on FirebaseAuthException catch(e) {
      if(e.code == "email-already-in-use") {
        isExistingEmail = true;
      } 
      else if(e.code == "invalid-email") {
        isEmailFormatError = true;
      }
      else {
        errorMessage = "Sign up failed: ${e.message}";
      }
      return false;
    }
  }

  void resetAllCheckingPoints() {
    isEmailFormatError = false;
    isExistingEmail = false;
    errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalMargin = size.width/9.57;
    final verticalRatio = size.height/874;
    final unitItemSpace = size.height/43.7;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        iconSize: 40 * verticalRatio,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.chevron_left_sharp,
                        )
                      ),
                    ),
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25 * verticalRatio,
                        fontFamily: 'Outfit'
                      ),
                    ),
                  ],
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
                  controller: controllers["Name"],
                  cursorColor: Color.fromARGB(255, 62, 85, 97),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person,color: Color.fromARGB(255, 62, 85, 97)),
                    hintText: "Full name",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 62, 85, 97),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 62, 85, 97),
                  ),
                  validator: (value) {
                    if(value == null  || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
              ),
          
              Container(
                margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, top: unitItemSpace*1.75),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(85, 215, 215, 215),
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextFormField(
                  controller: controllers["Email"],
                  cursorColor: Color.fromARGB(255, 62, 85, 97),
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail,color: Color.fromARGB(255, 62, 85, 97)),
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
                  validator: (value) {
                    if(value == null  || value.isEmpty) {
                      return 'Email is required';
                    }
                    
                    if(isEmailFormatError) {
                      return 'The email is invalid';
                    }
                    if(isExistingEmail) {
                      return 'Email is already in use';
                    }
                    return null;
                  },
                ),
              ),
          
              Container(
                margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, top: unitItemSpace*1.75),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(85, 215, 215, 215),
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextFormField(
                  controller: controllers["Address"],
                  cursorColor: Color.fromARGB(255, 62, 85, 97),
                  decoration: InputDecoration(
                    icon: Icon(Icons.local_shipping,color: Color.fromARGB(255, 62, 85, 97)),
                    hintText: "Shipping address",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 62, 85, 97),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 62, 85, 97),
                  ),
                  validator: (value) {
                    if(value == null  || value.isEmpty) {
                      return 'Shipping address is required';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, top: unitItemSpace*1.75),
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
                  validator: (value) {
                    if(value == null  || value.isEmpty) {
                      return 'Password is required';
                    }
                    if(value.length < 6) {
                      return 'Password is at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
          
              Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: unitItemSpace*1.75, left: horizontalMargin, right: horizontalMargin),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 62, 85, 97),
                ),
                onPressed: () async {
                  resetAllCheckingPoints();
                  bool isSuccess = await signUp();
                  formKey.currentState!.validate();
                  if(!mounted) return;
                  if(isSuccess) {
                    showSuccessSnackBar(context);
                    AppUser user = createAppUser(
                      email: controllers["Email"]!.text,
                      fullName: controllers["Name"]!.text,
                      shippingAddress: controllers["Address"]!.text
                    );
                    // Save user information to firebase
                    await saveUserInformation(user: user);

                    setState(() {
                      controllers["Email"]!.text = "";
                      controllers["Address"]!.text = "";
                      controllers["Name"]!.text = "";
                      controllers["Password"]!.text = "";
                    });
                  }
                  else {
                    showSignUpFailureSnackBar(context, errorMessage: errorMessage.isEmpty ? "Failed to create account" : errorMessage);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15 * verticalRatio),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: verticalRatio * 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit'
                    ),
                  ),
                ),
              ),
            ),
          
            ],
          ),
        ),
      ),
    );
  }
}