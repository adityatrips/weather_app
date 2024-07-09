import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const darkTheme = ColorScheme.dark(
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
  );

  static const ColorScheme lightTheme = ColorScheme.light(
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
  );

  static final light = ThemeData(
    dividerTheme: const DividerThemeData(
      color: Colors.transparent,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: GoogleFonts.bebasNeue(),
        side: BorderSide.none,
      ),
    ),
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: lightTheme,
  );
  static final dark = ThemeData(
    dividerTheme: const DividerThemeData(
      color: Colors.transparent,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: GoogleFonts.bebasNeue(),
        side: BorderSide.none,
      ),
    ),
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: darkTheme,
  );
}
