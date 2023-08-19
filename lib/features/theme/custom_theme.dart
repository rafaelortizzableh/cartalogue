import 'package:flutter/material.dart';

abstract class CustomTheme {
  static const primaryColor = Colors.deepPurple;
  static const errorRed = Colors.red;

  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      useMaterial3: true,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      useMaterial3: true,
    );
  }
}
