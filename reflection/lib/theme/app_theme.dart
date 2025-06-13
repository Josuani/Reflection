import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/pixel_background.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6B4EFF);
  static const Color accentColor = Color(0xFFFF6B4E);
  static const Color surfaceColor = Color(0xFF2A2A2A);
  static const Color backgroundColor = Color(0xFF1A1A1A);
  static const Color textColor = Color(0xFFFFFFFF);

  // Text Styles
  static TextStyle get titleStyle => GoogleFonts.pressStart2p(
        fontSize: 24,
        color: textColor,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get subtitleStyle => GoogleFonts.pressStart2p(
        fontSize: 16,
        color: textColor,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyStyle => GoogleFonts.pressStart2p(
        fontSize: 14,
        color: textColor,
        fontWeight: FontWeight.normal,
      );

  static ButtonStyle get retroButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: textColor, width: 2),
        ),
      );

  // Theme Data
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      background: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: TextTheme(
      displayLarge: titleStyle,
      displayMedium: subtitleStyle,
      bodyLarge: bodyStyle,
      bodyMedium: bodyStyle.copyWith(fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: retroButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: bodyStyle,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: bodyStyle.copyWith(fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: bodyStyle.copyWith(color: textColor),
      hintStyle: bodyStyle.copyWith(color: textColor),
    ),
    cardTheme: const CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: titleStyle.copyWith(fontSize: 20),
      iconTheme: const IconThemeData(color: textColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textColor,
    ),
  );

  // Widgets
  static Widget getBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor,
        image: DecorationImage(
          image: AssetImage('assets/images/pixel/background.png'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
    );
  }
} 