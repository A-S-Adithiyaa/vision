import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision/authentication/login-screen.dart';
import 'package:vision/custom-variables.dart';
import 'package:vision/home-page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isPasswordVisible = false;

  Future<void> _signUp(BuildContext context) async {
    try {
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Set display name for the user
      User? user = authResult.user;
      await user?.updateProfile(displayName: usernameController.text);
      await user?.reload();

      // Store additional information in Firestore
      // await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      //   'username': usernameController.text,
      //   'phoneNumber': phoneNumberController.text, // You can add the user's phone number here
      // });

      // Navigate to HomePage after successful signup
      navigateWithCustomTransitionForward(context, const HomePageCaller());
    } catch (e) {
      // Handle signup errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: getNunito(fontSize: 23, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: MyColors.primaryWhite,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                'assets/images/splashScreenLogo.png',
                height: 300,
                width: 300,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: getNunito(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: MyColors.inputBG,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: getNunito(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: MyColors.inputBG,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !isPasswordVisible,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: getNunito(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: MyColors.inputBG,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: getNunito(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: MyColors.inputBG,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signUp(context),
              child: Text(
                'Sign Up',
                style: getNunito(),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 40), backgroundColor: MyColors.comet),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                navigateWithCustomTransitionForward(context, LoginScreen());
              },
              child: Text(
                'Already have an account? Login',
                style: getNunito(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
