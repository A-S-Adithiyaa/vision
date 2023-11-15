import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vision/custom-variables.dart';

class HomePage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomePage({super.key});

  Future<List<Map<String, dynamic>>> getVideoViewList() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Check if the user is authenticated
      if (user != null) {
        // Fetch user's history from Firestore
        final userInfo = await _firestoreService.getUserInfo(user.uid);
        List<Map<String, dynamic>> history = userInfo['history'] ?? [];

        return history;
      } else {
        // User not authenticated, return empty list
        return [];
      }
    } catch (e) {
      print('Error retrieving video view list: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Hemisphere
          Positioned(
            top: -200,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              child: CustomPaint(
                painter: HemispherePainter(),
              ),
            ),
          ),
          // Left Container
          Positioned(
            left: 32,
            top: 250,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 45,
              height: 150,
              decoration: BoxDecoration(
                  color: MyColors.primaryWhite, // Adjust color as needed
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: MyColors.primaryBlue)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.history,
                      size: 50,
                      color: MyColors.primaryBlue,
                    ),
                    Column(
                      children: [
                        Text(
                          'Last Login',
                          style: getNunito(
                            fontSize: 18,
                            color: Colors.black, // Adjust color as needed
                          ),
                        ),
                        FutureBuilder(
                          future:
                              _firestoreService.getUserInfo(user?.uid ?? ''),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: getNunito(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              var lastLoginTime = user?.metadata.lastSignInTime;
                              var formattedLastLoginTime = lastLoginTime != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(lastLoginTime)
                                  : 'N/A';

                              return Text(
                                formattedLastLoginTime,
                                style: getNunito(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right Container
          Positioned(
            right: 32,
            top: 250,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 45,
              height: 150,
              decoration: BoxDecoration(
                  color: MyColors.primaryWhite, // Adjust color as needed
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: MyColors.primaryBlue)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.recommend_outlined,
                      size: 50,
                      color: MyColors.primaryBlue,
                    ),
                    Column(
                      children: [
                        Text(
                          'Recent Origami',
                          style: getNunito(
                            fontSize: 18,
                            color: Colors.black, // Adjust color as needed
                          ),
                        ),
                        FutureBuilder(
                          future:
                              _firestoreService.getUserInfo(user?.uid ?? ''),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: getNunito(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              print(snapshot.data);
                              return Text(
                                "${snapshot.data?['recentOrigami'] ?? 'NIL'}",
                                style: getNunito(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
              top: 420,
              left: 25,
              child: Text(
                "History",
                style: getNunito(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          // List of Items
          Positioned(
            top: 450,
            left: 16,
            right: 16,
            bottom: 16,
            child: FutureBuilder(
              future: getVideoViewList(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        )),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index]; 
                      return Card(
                        // color: MyColors.inputBG,
                        margin: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item['origamiName'] ?? '',
                                    style: getNunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: MyColors.primaryBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    item['timeOfView'] != null
                                        ? DateFormat('dd-MM-yyyy HH:mm:ss')
                                            .format(
                                            (item['timeOfView'] as Timestamp)
                                                .toDate(),
                                          )
                                        : '',
                                    style: getNunito(
                                      fontSize: 14,
                                      color: MyColors.primaryBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.play_circle_filled,
                                color: MyColors.primaryBlue,
                              ),
                            ],
                          ),
                          onTap: () async {
                            String linkToOpen =
                                item['videoLink']!; // Replace with your link

                            // if (await canLaunch(linkToOpen)) {
                            await launch(linkToOpen);
                            // } else {
                            //   // Handle the case where the URL can't be launched
                            //   print("Could not launch $linkToOpen");
                            // }
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: FutureBuilder(
                future: _firestoreService.getUserInfo(user?.uid ?? ''),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: getNunito(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: MyColors.primaryWhite,
                      ),
                    );
                  } else {
                    return Text(
                      'Welcome, ${snapshot.data?['username'] ?? 'Guest'}!',
                      style: getNunito(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: MyColors.primaryWhite,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HemispherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    // Draw a hemisphere
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      0,
      pi,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
