import 'package:flutter/material.dart';

// Define color constants from your palette
const Color coffee = Color(0xFF644536); // Primary Color
const Color redwood = Color(0xFFB2675E); // Secondary Color
const Color lion = Color(0xFFC4A381); // Tertiary Color
const Color pistachio = Color(0xFFBBD686); // Accent Color
const Color cream = Color(0xFFEEF1BD); // Background Color

ThemeData buildAppTheme() {
  return ThemeData(
    // General color scheme
    primaryColor: coffee,
    primarySwatch: Colors.brown, // Use a similar brown color swatch
    scaffoldBackgroundColor: cream,

    // App bar configuration
    appBarTheme: const AppBarTheme(
      color: coffee,
      elevation: 4,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white, // White icons on the app bar
      ),
    ),

    // Button theme
    buttonTheme: const ButtonThemeData(
      buttonColor: redwood, // Secondary color for buttons
      textTheme: ButtonTextTheme.primary, // Use primary color for button text
    ),

    // Text theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: coffee,
      ),
      titleMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: coffee,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: lion,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: lion,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: redwood,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white, // White button text
      ),
    ),

    // Input decoration (for form fields, text inputs)
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(color: lion),
      labelStyle: const TextStyle(color: coffee),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: lion, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: pistachio, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: pistachio,
      foregroundColor: Colors.black,
    ),

    // Bottom navigation bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: coffee,
      selectedItemColor: pistachio,
      unselectedItemColor: lion,
    ),

    // Card theme
    cardTheme: CardTheme(
      color: lion,
      shadowColor: Colors.black.withOpacity(0.1),
      elevation: 4,
      margin: const EdgeInsets.all(8),
    ),

    // Dialog Theme
    dialogTheme: const DialogTheme(
      backgroundColor: cream,
      titleTextStyle: TextStyle(
        color: coffee,
        fontSize: 20,
      ),
      contentTextStyle: TextStyle(
        color: lion,
      ),
    ),
  );
}
