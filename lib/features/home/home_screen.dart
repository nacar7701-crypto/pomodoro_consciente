import 'package:flutter/material.dart';
import 'package:pomodoro_consciente/main.dart';
import 'package:pomodoro_consciente/features/timer/timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controladores para capturar lo que el usuario escribe
  final _materiaController = TextEditingController();
  final _objetivoController = TextEditingController();

  @override
  void dispose() {
    _materiaController.dispose();
    _objetivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Consciente 🍅'),
        centerTitle: true,
        actions: [
          // Botón para alternar entre Modo Claro y Oscuro
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark 
                  ? Icons.light_mode 
                  : Icons.dark_mode
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              '¿Qué vamos a lograr hoy?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Campo de Texto: Materia
            TextField(
              controller: _materiaController,
              decoration: const InputDecoration(
                labelText: 'Materia o Proyecto',
                hintText: 'Ej: Programación, Matemáticas, Historia...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 24),
            
            // Campo de Texto: Objetivo
            TextField(
              controller: _objetivoController,
              decoration: const InputDecoration(
                labelText: '¿Cuál es tu objetivo concreto?',
                hintText: 'Ej: Resolver 5 ejercicios de POO',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.emoji_events),
              ),
            ),
            const SizedBox(height: 40),
            
            // Botón Principal para Iniciar la Sesión
            ElevatedButton(
              onPressed: () {
                final materia = _materiaController.text;
                final objetivo = _objetivoController.text;
                
                // Validación simple para que no inicien vacíos
                if (materia.isEmpty || objetivo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, llena ambos campos para empezar.'),
                    ),
                  );
                  return;
                }

                print('Sesión Iniciada -> Materia: $materia, Objetivo: $objetivo');
                // TODO: Navegar a la pantalla del temporizador (timer_screen.dart) pasándole estos datos
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      materia: materia,
                      objetivo: objetivo,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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