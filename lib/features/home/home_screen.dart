import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pomodoro_consciente/main.dart';
import 'package:pomodoro_consciente/features/timer/timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _materiaController = TextEditingController();
  final _objetivoController = TextEditingController();

  final List<String> _frases = [
    "Pequeños avances todos los días generan grandes resultados.",
    "No necesitas hacerlo perfecto, solo empezar.",
    "Descansar también es avanzar.",
    "La constancia supera a la perfección.",
    "Tu cerebro también necesita pausas.",
  ];

  // RF-02.1: Lista de objetivos sugeridos predefinidos
  final List<String> _objetivosRapidos = [
    "Resolver ejercicios",
    "Leer un capítulo",
    "Hacer un resumen",
    "Preparar examen",
    "Hacer una tarea",
  ];

  late String _fraseSeleccionada;

  // ⏱️ Variables de tiempo editables dinámicamente
  double _studyMinutes = 25;
  double _breakMinutes = 5;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _fraseSeleccionada = _frases[random.nextInt(_frases.length)];
  }

  @override
  void dispose() {
    _materiaController.dispose();
    _objetivoController.dispose();
    super.dispose();
  }

  String _obtenerSaludo() {
    final hora = DateTime.now().hour;
    if (hora < 12) return '☀️ Buenos días';
    if (hora < 19) return '🌤️ Buenas tardes';
    return '🌙 Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Consciente 🍅'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() {
                themeNotifier.value = themeNotifier.value == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Text(
              _obtenerSaludo(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Tarjeta de frase motivacional animada
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * -20),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 28,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '“$_fraseSeleccionada”',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurface.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              '¿Qué vamos a lograr hoy?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // 🛠️ Campo: Materia o Proyecto
            TextField(
              controller: _materiaController,
              decoration: const InputDecoration(
                labelText: 'Materia o Proyecto',
                hintText: 'Ej: Programación, Matemáticas...',
                prefixIcon: Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 24),

            // Campo de Texto: Objetivo (RF-02.4)
            TextField(
              controller: _objetivoController,
              decoration: const InputDecoration(
                labelText: '¿Cuál es tu objetivo concreto?',
                hintText: 'Ej: Resolver 5 ejercicios de POO',
                prefixIcon: Icon(Icons.emoji_events),
              ),
            ),
            const SizedBox(height: 12),

            // ⚡ SECCIÓN DE OBJETIVOS RÁPIDOS
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _objetivosRapidos.map((objetivo) {
                return ActionChip(
                  label: Text(objetivo),
                  avatar: const Icon(Icons.add, size: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    setState(() {
                      _objetivoController.text = objetivo;
                      _objetivoController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _objetivoController.text.length),
                      );
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // ⏱️ CONFIGURACIÓN DE TIEMPOS
            const Text(
              'Configuración de Tiempos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Slider: Tiempo de Estudio (Tomato Color)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tiempo de Estudio:', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  '${_studyMinutes.toInt()} min',
                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Slider.adaptive(
              value: _studyMinutes,
              min: 5,
              max: 60,
              divisions: 11, // Intervalos de 5 en 5 minutos
              activeColor: colorScheme.primary,
              inactiveColor: colorScheme.primary.withOpacity(0.2),
              onChanged: (value) {
                setState(() {
                  _studyMinutes = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Slider: Tiempo de Descanso (Amber Color)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tiempo de Descanso:', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  '${_breakMinutes.toInt()} min',
                  style: TextStyle(color: colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Slider.adaptive(
              value: _breakMinutes,
              min: 1,
              max: 30,
              divisions: 29, // Intervalos de 1 en 1 minuto
              activeColor: colorScheme.tertiary,
              inactiveColor: colorScheme.tertiary.withOpacity(0.2),
              onChanged: (value) {
                setState(() {
                  _breakMinutes = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // Botón Principal para Iniciar la Sesión
            ElevatedButton(
              onPressed: () {
                final materia = _materiaController.text.trim();
                final objetivo = _objetivoController.text.trim();

                if (materia.isEmpty || objetivo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, llena ambos campos para empezar.'),
                    ),
                  );
                  return;
                }

                // Navegamos pasando los tiempos elegidos al TimerScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      materia: materia,
                      objetivo: objetivo,
                      studyMinutes: _studyMinutes.toInt(),
                      breakMinutes: _breakMinutes.toInt(),
                    ),
                  ),
                );
              },
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}