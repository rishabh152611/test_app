import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green[800],
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(backgroundColor: Colors.green[800], foregroundColor: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.green[800]),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[900],
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[900],
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.greenAccent),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}