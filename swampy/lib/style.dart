import 'package:flutter/material.dart';

class Style {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xff416BE0),
    backgroundColor: Colors.white,
    errorColor: Color(0xffED2939),

    fontFamily: 'Montserrat',

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
  );
}