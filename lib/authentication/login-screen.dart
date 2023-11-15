import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision/authentication/signup-screen.dart';
import 'package:vision/custom-variables.dart';
import 'package:vision/app-page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to HomePageCaller after successful login
      navigateWithCustomTransitionForward(context, const AppPage());
    } catch (e) {
      // Handle login errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
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
                height: 250,
                width: 250,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: getNunito(),
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
              style: getNunito(),
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
              onPressed: () => _login(context),
              child: Text(
                'Login',
                style: getNunito(),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 40),
                  backgroundColor: MyColors.primaryBlue),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                navigateWithCustomReverseTransition(context, SignUpScreen());
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: getNunito(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
