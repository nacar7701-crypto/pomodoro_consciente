import 'package:flutter/material.dart';

class AppTheme {
  // 🍅 Color principal (tomate coral)
  static const Color tomatoRed = Color(0xFFE76F51);

  // 🌿 Verde para bienestar y logros
  static const Color sageGreen = Color(0xFF5FA777);

  // ☕ Ámbar para descansos
  static const Color restAmber = Color(0xFFF4A261);

  // 🌙 Modo oscuro
  static const Color darkBackground = Color(0xFF18181B);
  static const Color darkSurface = Color(0xFF232326);
  static const Color darkSurfaceVariant = Color(0xFF2E2E33);
  static const Color textWhite = Color(0xFFF8F9FA);

  // ☀️ Modo claro
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceVariant = Color(0xFFF1F3F5);
  static const Color textDark = Color(0xFF1F2937);

  // 🌙 TEMA OSCURO
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,

      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark, // Asegura sincronización
        primary: tomatoRed,
        secondary: sageGreen,
        tertiary: restAmber,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textWhite,
      ),

      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant, // Un toque más claro que el fondo para resaltar
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none, // Diseño moderno sin bordes duros si está lleno
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: tomatoRed, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tomatoRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  // ☀️ TEMA CLARO
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,

      colorScheme: const ColorScheme.light(
        brightness: Brightness.light, // Asegura sincronización
        primary: tomatoRed,
        secondary: sageGreen,
        tertiary: restAmber,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),

      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceVariant, // CORREGIDO: Ahora usa un gris claro refinado
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: tomatoRed, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tomatoRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}