import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vision/authentication/signup-login-page.dart';
import 'package:vision/authentication/signup-screen.dart';
import 'package:vision/components/home-page.dart';
import 'package:vision/components/profile-page.dart';
import 'package:vision/custom-variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppPageCaller extends StatelessWidget {
  const AppPageCaller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Number of tabs
        child: AppPage(),
      ),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          HomePage(),
          ScanSection(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        child: TabBar(
          indicator: MyCustomIndicator(),
          tabs: const [
            Tab(icon: Icon(Icons.home, color: Colors.black)),
            Tab(icon: Icon(Icons.qr_code_scanner, color: Colors.black)),
            Tab(icon: Icon(Icons.person, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class AppSection extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _firestoreService.getUserInfo(user?.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Welcome, Loading...');
            } else {
              print(snapshot);
              return Text(
                'Welcome, ${snapshot.data?['username'] ?? 'Guest'}!',
                style: getNunito(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: MyColors.primaryBlack,
                ),
              );
            }
          },
        ),
        backgroundColor: MyColors.primaryWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: MyColors.martinique,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              navigateWithCustomReverseTransition(context, SignupLoginPage());
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'App Content',
          style: getNunito(fontSize: 20),
        ),
      ),
    );
  }
}

class ScanSection extends StatelessWidget {
  const ScanSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Scan Content',
        style: getNunito(fontSize: 20),
      ),
    );
  }
}
