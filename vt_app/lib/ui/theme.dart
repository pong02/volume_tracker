import 'package:flutter/material.dart';

class AppTheme {
  //main color: #50f3a7 (TTGL green) ==  rgb(80, 243, 167)
  static const mainGreen = Color.fromRGBO(80, 243, 167, 1);
  static const mainGreenSplash = Color.fromRGBO(80, 243, 167, 0.65);

  static const secondaryGreen = Color.fromARGB(255, 80, 243, 88);
  static const secondaryGreenSplash = Color.fromARGB(180, 80, 243, 88);

  static const darkBG = Color.fromRGBO(38, 38, 38, 1);
  static const lightBG = Color.fromRGBO(255, 255, 255, 1);

  static const defSubtitle = Color.fromARGB(255, 201, 201, 201);
  static const lightSubtitle = Color.fromARGB(255, 58, 58, 58);

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
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
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
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
  );

  //normal text style
  static const defTextStyleNormal = TextStyle(color: lightBG, fontSize: 14.0);
  static const defTextStyleBolded =
      TextStyle(color: lightBG, fontSize: 14.0, fontWeight: FontWeight.bold);
  static const defTextStyleHighlighted =
      TextStyle(color: mainGreen, fontSize: 14.0, fontWeight: FontWeight.bold);
  static const defTextStyleSub =
      TextStyle(color: lightSubtitle, fontSize: 13.0);
  static const defTextStyleTitleColored =
      TextStyle(fontWeight: FontWeight.w500, color: mainGreen, fontSize: 30.0);
  static const defTextStyleTitle =
      TextStyle(fontWeight: FontWeight.w500, color: lightBG, fontSize: 30.0);

  //light text style
  static const lightTextStyleNormal = TextStyle(color: darkBG, fontSize: 14.0);
  static const lightTextStyleBolded =
      TextStyle(color: darkBG, fontSize: 14.0, fontWeight: FontWeight.bold);
  static const lightStyleHighlighted = TextStyle(
      color: secondaryGreen, fontSize: 14.0, fontWeight: FontWeight.bold);
  static const lightTextStyleSub =
      TextStyle(color: lightSubtitle, fontSize: 13.0);
  static const lightTextStyleTitleColored = TextStyle(
      fontWeight: FontWeight.w500, color: secondaryGreen, fontSize: 30.0);
  static const lightTextStyleTitle =
      TextStyle(fontWeight: FontWeight.w500, color: darkBG, fontSize: 30.0);
}
