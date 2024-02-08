import 'package:flutter/material.dart';

class CustomThemeData {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color.fromARGB(255, 248, 168, 212),
    hintColor: Colors.green,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
    hintColor: Colors.yellow,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
    ),
  );
}
