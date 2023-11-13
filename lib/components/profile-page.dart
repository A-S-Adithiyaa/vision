import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision/custom-variables.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _firestoreService.getUserInfo(user?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            String username = snapshot.data?['username'] ?? 'Guest';
            String phoneNumber = snapshot.data?['phoneNumber'] ?? 'No Phone Number';

            return Column(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 100,
                  ),
                ),
                ClipOval(
                  child: Container(
                    width: 135.0, // Adjust the size as needed
                    height: 135.0, // Adjust the size as needed
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyColors.primaryBlue, // Neon border color
                        width: 2.0,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/splashScreenLogo.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '$username', // Display the username
                  style: getNunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: MyColors.primaryBlack),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Personal Information",
                            style: getNunito(fontSize: 18),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.drive_file_rename_outline_outlined,
                                color: MyColors.primaryBlue,
                              ),
                              Text(
                                "Edit",
                                style: getNunito(
                                    fontSize: 18, color: MyColors.primaryBlue),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyColors.inputBG,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.perm_identity),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Username",
                                          style: getNunito(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "$username",
                                      style: getNunito(),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.mail),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Email",
                                          style: getNunito(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${user?.email ?? 'No Email'}",
                                      style: getNunito(),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.phone),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Phone",
                                          style: getNunito(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "$phoneNumber",
                                      style: getNunito(),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}