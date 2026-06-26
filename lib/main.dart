import 'package:flutter/material.dart';
import 'package:pomodoro_consciente/core/theme/app_theme.dart';
import 'package:pomodoro_consciente/features/home/home_screen.dart';

// Este objeto global guardará si el tema actual es oscuro (true) o claro (false)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(const PomodoroConscienteApp());
}

class PomodoroConscienteApp extends StatelessWidget {
  const PomodoroConscienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // El ValueListenableBuilder redibuja la app automáticamente cuando cambia el tema
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode, // Aquí se define cuál usar
          home: const HomeScreen(),
        );
      },
    );
  }
}