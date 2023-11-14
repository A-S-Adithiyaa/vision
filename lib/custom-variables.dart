import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// git token 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

class MyColors {
  static const Color malibu = Color.fromRGBO(90, 217, 248, 1);
  static const Color danube = Color.fromRGBO(101, 117, 212, 1);
  static const Color martinique = Color.fromRGBO(60, 52, 85, 1);
  static const Color wedgewood = Color.fromRGBO(77, 129, 154, 1);
  static const Color butterflyBush = Color.fromRGBO(82, 81, 146, 1);
  static const Color blueBayoux = Color.fromRGBO(69, 88, 118, 1);
  static const Color deluge = Color.fromRGBO(116, 101, 162, 1);
  static const Color hippieBlue = Color.fromRGBO(81, 164, 172, 1);
  static const Color comet = Color.fromRGBO(92, 93, 122, 1);
  static const Color primaryWhite = Color.fromRGBO(250, 250, 250, 1);
  static const Color primaryBlue = Color.fromRGBO(33, 150, 243, 1);
  static const Color inputBG = Color.fromRGBO(211, 246, 255, 1);
  static const Color primaryBlack = Color.fromRGBO(0, 0, 0, 1);
}

// Define the font family
const String nunitoFontFamily = 'Nunito';

TextStyle getNunito(
    {double fontSize = 16.0,
    Color? color,
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
    fontFamily: nunitoFontFamily,
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: color,
  );
}

class MyCustomIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyCustomIndicatorPainter(this, onChanged);
  }
}

class _MyCustomIndicatorPainter extends BoxPainter {
  final MyCustomIndicator decoration;

  _MyCustomIndicatorPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint();
    paint.color = MyColors.malibu; // Set the color of the circle

    const double radius = 18; // Adjust the radius of the circle
    final Offset circleCenter =
        Offset(rect.center.dx, rect.bottom - radius - 6);

    canvas.drawCircle(circleCenter, radius, paint);
  }
}

void navigateWithCustomTransitionForward(
    BuildContext context, Widget targetPage) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    ),
  );
}

void navigateWithCustomReverseTransition(
    BuildContext context, Widget targetPage) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    ),
  );
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Extract username, phoneNumber, profileImageUrl, and history from Firestore
        String username = userSnapshot['username'];
        String phoneNumber = userSnapshot['phoneNumber'];
        String profileImageUrl = userSnapshot['profileImageUrl'];
        List<Map<String, dynamic>> history =
            List<Map<String, dynamic>>.from(userSnapshot['history'] ?? []);

        return {
          'username': username,
          'phoneNumber': phoneNumber,
          'profileImageUrl': profileImageUrl,
          'history': history,
        };
      } else {
        return {
          'username': 'Guest',
          'phoneNumber': 'xxxxxxxxxx',
          'profileImageUrl': '',
          'history': [],
        };
      }
    } catch (e) {
      print('Error retrieving user info: $e');
      return {
        'username': 'Guest',
        'phoneNumber': 'xxxxxxxxxx',
        'profileImageUrl': '',
        'history': [],
      };
    }
  }

  Future<List<Map<String, dynamic>>> getLinksData() async {
    try {
      DocumentSnapshot linksSnapshot = await _firestore
          .collection('links')
          .doc('mBuZ4l0AveQkEIZEOo6j')
          .get();

      if (linksSnapshot.exists) {
        // Extract the "fields" array from Firestore
        List<dynamic> fieldsArray = linksSnapshot['links'] ?? [];
        print(fieldsArray);

        // Convert the array into a list of maps
        List<Map<String, dynamic>> linksData = List<Map<String, dynamic>>.from(
          fieldsArray.map(
            (field) => {
              'origamiName': field['origamiName'] ?? '',
              'videoLink': field['videoLink'] ?? '',
            },
          ),
        );
        return linksData;
      } else {
        return [];
      }
    } catch (e) {
      print('Error retrieving links data: $e');
      return [];
    }
  }
}
