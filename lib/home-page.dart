import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vision/authentication/signup-screen.dart';
import 'package:vision/custom-variables.dart';

class HomePageCaller extends StatelessWidget {
  const HomePageCaller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Number of tabs
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, W!K!',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: MyColors.martinique,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              navigateWithCustomReverseTransition(context, SignUpScreen());
            },
          ),
        ],
      ),
      body: const TabBarView(
        children: [
          HomeSection(),
          ScanSection(),
          ProfileSection(),
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

class HomeSection extends StatelessWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.primaryWhite,
      child: Center(
        child: Text(
          'Home Content',
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

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Content',
        style: getNunito(fontSize: 20),
      ),
    );
  }
}
