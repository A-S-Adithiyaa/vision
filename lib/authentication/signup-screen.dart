import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision/authentication/login-screen.dart';
import 'package:vision/custom-variables.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  Future<void> _signUp(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
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
                fillColor: MyColors.inputBG, // Background color
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: getNunito(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: MyColors.inputBG, // Background color
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0)),
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
