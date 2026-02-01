import 'package:flutter/material.dart';

class AppTheme {
  // Custom Color Palette: Purple, Pink, Orange, Black
  static const Color primaryColor = Color(0xFF7C3AED);        // Purple
  static const Color primaryLight = Color(0xFFA78BFA);        // Light purple
  static const Color secondaryColor = Color(0xFFEC4899);      // Pink
  static const Color tertiaryColor = Color(0xFFF97316);       // Orange
  static const Color accentColor = Color(0xFFF97316);         // Orange
  static const Color successColor = Color(0xFF10B981);        // Green
  static const Color warningColor = Color(0xFFFFA726);        // Orange warning
  static const Color dangerColor = Color(0xFFEF5350);         // Red
  
  static const Color darkColor = Color(0xFF0A0A0A);           // Black
  static const Color darkBg = Color(0xFF0A0A0A);              // Black
  // Light background: soft lavender to match purple/pink palette
  static const Color lightBg = Color(0xFFF3E8FF);
  static const Color cardBg = Color(0xFFFFFFFF);              // White
  static const Color borderColor = Color(0xFFE5E7EB);
  
  static const Color textPrimary = Color(0xFF1F2937);         // Dark gray/black
  static const Color textSecondary = Color(0xFF6B7280);       // Gray
  static const Color textLight = Color(0xFFD1D5DB);           // Light gray

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Poppins',
      
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardBg,
        outline: borderColor,
        error: dangerColor,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: darkBg,
      fontFamily: 'Poppins',
      
      colorScheme: ColorScheme.dark(
        primary: primaryLight,
        secondary: secondaryColor,
        surface: const Color(0xFF1F1F1F),
        outline: const Color(0xFF2D2D2D),
        error: dangerColor,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: textLight),
        titleTextStyle: const TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
