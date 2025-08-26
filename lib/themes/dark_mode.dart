import 'package:flutter/material.dart';

final ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Color(0xFF2A2A2A),
    onSecondary: Colors.white,
    surface: Color(0xFF121212),
    onSurface: Colors.white,
    surfaceVariant: Color(0xFF1E1E1E),
    outline: Color(0xFF3C3C3C),
    background: Color(0xFF0F0F0F),
    onBackground: Colors.white,
    inversePrimary: Color(0xFFBBBBBB),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F0F0F),
  textTheme: Typography.whiteCupertino.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
  ),
);
