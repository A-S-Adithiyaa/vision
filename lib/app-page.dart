import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vision/authentication/signup-login-page.dart';
import 'package:vision/authentication/signup-screen.dart';
import 'package:vision/components/home-page.dart';
import 'package:vision/components/profile-page.dart';
import 'package:vision/components/scan-page.dart';
import 'package:vision/custom-variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Check if the widget is still mounted
          if (!mounted) return false;

          // If we are on the second or third tab, switch to the first tab
          if (_tabController.index != 0) {
            _tabController.animateTo(0);
            return false; // Prevent default back button behavior
          }
          return true; // Allow default back button behavior
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            HomePage(),
            ScanPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: TabBar(
          controller: _tabController,
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
