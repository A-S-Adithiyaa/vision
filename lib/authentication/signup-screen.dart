import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision/authentication/login-screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vision/custom-variables.dart';
import 'package:vision/app-page.dart';

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
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirestoreStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images/$fileName.jpg');

      firebase_storage.UploadTask uploadTask = reference.putFile(imageFile);

      // Wait until the image is uploaded
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      String downloadURL = await reference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Set display name for the user
      User? user = authResult.user;

      // Upload profile photo to Firestore Storage
      String imageUrl = '';
      if (_image != null) {
        imageUrl = await uploadImageToFirestoreStorage(_image!);
      }

      print(imageUrl);

      // Store additional information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'profileImageUrl': imageUrl,
        'username': usernameController.text,
        'phoneNumber': phoneNumberController.text,
      });

      // Navigate to HomePage after successful signup
      navigateWithCustomTransitionForward(context, const AppPageCaller());
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
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
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
                fillColor: MyColors.inputBG,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
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
              style: getNunito(),
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
              style: getNunito(),
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
