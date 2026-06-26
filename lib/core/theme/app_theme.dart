import 'package:flutter/material.dart';

class AppTheme {
  static const Color tomatoRed = Color(0xFFE56B55);
  static const Color sageGreen = Color(0xFF8AA882);
  
  // Colores Modo Oscuro
  static const Color darkCharcoal = Color(0xFF1E1E1E);
  static const Color surfaceGrey = Color(0xFF2D2D2D);
  static const Color textWhite = Color(0xFFF5F5F5);

  // Colores Modo Claro
  static const Color sandCream = Color(0xFFFDFBF7);
  static const Color textDark = Color(0xFF2B2B2B);

  // 1. TEMA OSCURO
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkCharcoal,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: tomatoRed,
        secondary: sageGreen,
        surface: surfaceGrey,
        onSurface: textWhite,
      ),
    );
  }

  // 2. TEMA CLARO
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: sandCream,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: tomatoRed,
        secondary: sageGreen,
        surface: Colors.white,
        onSurface: textDark,
      ),
    );
  }
}