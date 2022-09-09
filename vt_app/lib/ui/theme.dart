import 'package:flutter/material.dart';

class AppTheme {
  //main color: #50f3a7 (TTGL green) ==  rgb(80, 243, 167)
  static final mainGreen = Color.fromRGBO(80, 243, 167, 1);
  static final mainGreenSplash = Color.fromRGBO(80, 243, 167, 0.65);

  static final secondaryGreen = Color.fromARGB(255, 80, 243, 88);
  static final secondaryGreenSplash = Color.fromARGB(180, 80, 243, 88);

  static final darkBG = Color.fromRGBO(38, 38, 38, 1);
  static final lightBG = Color.fromRGBO(255, 255, 255, 1);

  static final defSubtitle = Color.fromARGB(255, 201, 201, 201);
  static final lightSubtitle = Color.fromARGB(255, 58, 58, 58);

  //normal(dark)
  static final defTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: mainGreen,
    splashColor: mainGreenSplash,
    backgroundColor: darkBG,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: mainGreen),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: mainGreen,
            onPrimary: Colors.black,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
  );

  //light
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: secondaryGreen,
    splashColor: secondaryGreenSplash,
    backgroundColor: lightBG,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: secondaryGreen),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: secondaryGreen,
            onPrimary: Colors.black,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
  );

  //normal text style
  static final defTextStyleNormal = TextStyle(color: lightBG, fontSize: 14.0);
  static final defTextStyleBolded =
      TextStyle(color: lightBG, fontSize: 14.0, fontWeight: FontWeight.bold);
  static final defTextStyleHighlighted =
      TextStyle(color: mainGreen, fontSize: 14.0, fontWeight: FontWeight.bold);
  static final defTextStyleSub =
      TextStyle(color: lightSubtitle, fontSize: 13.0);
  static final defTextStyleTitleColored =
      TextStyle(fontWeight: FontWeight.w500, color: mainGreen, fontSize: 30.0);
  static final defTextStyleTitle =
      TextStyle(fontWeight: FontWeight.w500, color: lightBG, fontSize: 30.0);

  //light text style
  static final lightTextStyleNormal = TextStyle(color: darkBG, fontSize: 14.0);
  static final lightTextStyleBolded =
      TextStyle(color: darkBG, fontSize: 14.0, fontWeight: FontWeight.bold);
  static final lightStyleHighlighted = TextStyle(
      color: secondaryGreen, fontSize: 14.0, fontWeight: FontWeight.bold);
  static final lightTextStyleSub =
      TextStyle(color: lightSubtitle, fontSize: 13.0);
  static final lightTextStyleTitleColored = TextStyle(
      fontWeight: FontWeight.w500, color: secondaryGreen, fontSize: 30.0);
  static final lightTextStyleTitle =
      TextStyle(fontWeight: FontWeight.w500, color: darkBG, fontSize: 30.0);
}
