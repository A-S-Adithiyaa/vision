import 'package:flutter/material.dart';
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
          style: getNunito(
              fontSize: 27,
              fontWeight: FontWeight.w500,
              color: Colors
                  .black), // Example of using light style in the app bar title
        ),
        backgroundColor: MyColors.primaryWhite,
        elevation: 0,
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
          indicator: MyCustomIndicator(), // Use the custom indicator
          tabs: const [
            Tab(icon: Icon(Icons.home, color: MyColors.martinique)),
            Tab(icon: Icon(Icons.qr_code_scanner, color: MyColors.martinique)),
            Tab(icon: Icon(Icons.person, color: MyColors.martinique)),
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
