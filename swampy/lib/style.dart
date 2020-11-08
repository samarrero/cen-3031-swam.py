import 'dart:js';

import 'package:flutter/material.dart';

class Style {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xff416BE0),
    backgroundColor: Colors.white,
    errorColor: Color(0xffED2939),

    fontFamily: 'Montserrat',

    //TODO: MAKE ALL FONTS BOLD
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 50.50, fontWeight: FontWeight.w300, color: Colors.black),
      headline2: TextStyle(fontSize: 37.89, fontWeight: FontWeight.w500, color: Colors.black),
      headline3: TextStyle(fontSize: 28.42, fontWeight: FontWeight.w500, color: Colors.black),
      headline4: TextStyle(fontSize: 21.32, fontWeight: FontWeight.w500, color: Colors.black),
      headline5: TextStyle(fontSize: 16.00, fontWeight: FontWeight.w500, color: Colors.black),
      headline6: TextStyle(fontSize: 12.00, fontWeight: FontWeight.w700, color: Colors.black),
      subtitle1: TextStyle(fontSize: 12.00, fontWeight: FontWeight.w500, color: Colors.black),
      subtitle2: TextStyle(fontSize: 9.00, fontWeight: FontWeight.w700, color: Colors.black),
      bodyText1: TextStyle(fontSize: 12.00, fontWeight: FontWeight.w400, color: Colors.black),
      bodyText2: TextStyle(fontSize: 9.00, fontWeight: FontWeight.w500, color: Colors.black),
      button: TextStyle(fontSize: 21.32, fontWeight: FontWeight.w700, color: Colors.black),
      overline: TextStyle(fontSize: 16.00, fontWeight: FontWeight.w900, color: Color(0xff416BE0)),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: Color(0xff416BE0),
      inactiveTrackColor: Colors.grey[300],
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 2.0,
      rangeThumbShape: CustomThumbShape(),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      overlappingShapeStrokeColor: Colors.transparent,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Color(0xff416BE0),
      valueIndicatorTextStyle: TextStyle(fontSize: 12.00, fontWeight: FontWeight.w500, color: Colors.white),
    )
  );
}

class CustomThumbShape implements RangeSliderThumbShape {

  const CustomThumbShape({
    this.radius = 6.0,
    this.ringColor = const Color(0xff416BE0),
  });

  /// Outer radius of thumb

  final double radius;

  /// Color of ring

  final Color ringColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        bool isPressed,
        bool isEnabled,
        bool isOnTop,
        TextDirection textDirection,
        SliderThemeData sliderTheme,
        Thumb thumb}) {
    final Canvas canvas = context.canvas;

    // To create a ring create outer circle and create an inner cicrle then
    // subtract inner circle from outer circle and you will get a ring shape
    // fillType = PathFillType.evenOdd will be used for that

    Path path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..addOval(Rect.fromCircle(center: center, radius: radius - 6))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, Paint()..color = ringColor);
  }
}