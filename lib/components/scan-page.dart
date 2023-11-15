import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vision/custom-variables.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: FutureBuilder(
        future: _firestoreService.getLinksData(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                        Text(
                          item['origamiName'] ?? '',
                          style: getNunito(
                            fontSize: 14,
                            color: MyColors.primaryBlack,
                          ),
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

                      String userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      print(userId);
                      // Add the entry to the user's history array
                      await _firestore.collection('users').doc(userId).update({
                        'history': FieldValue.arrayUnion([
                          {
                            'origamiName': item['origamiName'] ?? '',
                            'timeOfView': DateTime.now().toUtc(),
                            'videoLink': linkToOpen,
                          },
                        ]),
                        'recentOrigami': item['origamiName'],
                      });

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
    );
  }
}
