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
