import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vision/custom-variables.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  final FirestoreService _firestoreService = FirestoreService();

  File? _newImage;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch existing data and initialize controllers
    fetchData();
  }

  Future<void> fetchData() async {
    final snapshot = await _firestoreService.getUserInfo(user?.uid ?? '');
    if (snapshot.isNotEmpty) {
      setState(() {
        usernameController.text = snapshot['username'] ?? '';
        phoneNumberController.text = snapshot['phoneNumber'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _firestoreService.getUserInfo(user?.uid ?? ''),
        builder: (context, snapshot) {
          String username = snapshot.data?['username'] ?? 'Guest';
          String phoneNumber =
              snapshot.data?['phoneNumber'] ?? 'No Phone Number';
          String profileImageUrl = snapshot.data?['profileImageUrl'] ?? '';

          return Column(
            children: [
              Flexible(
                child: SizedBox(
                  height: 100,
                ),
              ),
              Flexible(
                child: ClipOval(
                  child: Container(
                    width: 135.0,
                    height: 135.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: MyColors.primaryBlue, // Neon border color
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        image: _newImage != null
                            ? FileImage(_newImage!)
                            : profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                    as ImageProvider<Object>
                                : const AssetImage(
                                        'assets/images/splashScreenLogo.png')
                                    as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Edit icon in bottom-right corner
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: MyColors.comet,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                File? newImage = await getImageFromPicker();
                                if (newImage != null) {
                                  setState(() {
                                    _newImage = newImage;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          TextField(
                            style: getNunito(),
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle:
                                  getNunito(fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: MyColors.inputBG,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            style: getNunito(),
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle:
                                  getNunito(fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: MyColors.inputBG,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Check if username or phone number is changed
                  bool isUserDataChanged =
                      usernameController.text != snapshot.data?['username'] ||
                          phoneNumberController.text !=
                              snapshot.data?['phoneNumber'];

                  // Upload new image to storage if it's not null
                  String newImageUrl = '';
                  if (_newImage != null) {
                    newImageUrl =
                        await uploadImageToFirestoreStorage(_newImage!);
                  }

                  // Update the profile image URL and user data in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .update({
                    if (_newImage != null) 'profileImageUrl': newImageUrl,
                    if (isUserDataChanged) 'username': usernameController.text,
                    if (isUserDataChanged)
                      'phoneNumber': phoneNumberController.text,
                  });

                  Navigator.pop(context); // Close the EditProfilePage
                },
                child: Text(
                  'Save Changes',
                  style: getNunito(),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 40),
                  backgroundColor: MyColors.comet,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Future<File?> getImageFromPicker() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }

  return null;
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
