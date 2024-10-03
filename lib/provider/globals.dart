import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.blue,
    onPrimary: Colors.white,
    primaryContainer: Colors.blue,
    onPrimaryContainer: Colors.white,
    secondary: Colors.blue,
    onSecondary: Colors.white,
    secondaryContainer: Colors.blue,
    onSecondaryContainer: Colors.white,
    error: Colors.redAccent,
    onError: Colors.red,
    errorContainer: Colors.redAccent,
    onErrorContainer: Colors.white,
    outline: Color.fromRGBO(189, 189, 189, 1),
    surface: Color.fromRGBO(33, 33, 33, 1),
    onSurface: Colors.white,
    onSurfaceVariant: Colors.white,
  ),
);

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blue,
    onPrimary: Colors.black,
    primaryContainer: Colors.blue,
    onPrimaryContainer: Colors.black,
    secondary: Colors.blue,
    onSecondary: Colors.black,
    secondaryContainer: Colors.blue,
    onSecondaryContainer: Colors.black,
    error: Colors.redAccent,
    onError: Colors.red,
    errorContainer: Colors.redAccent,
    onErrorContainer: Colors.black,
    outline: Color.fromRGBO(189, 189, 189, 1),
    surface: Color.fromRGBO(33, 33, 33, 1),
    onSurface: Colors.black,
    onSurfaceVariant: Colors.black,
  ),
);
