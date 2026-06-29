import 'dart:async';
import 'package:flutter/material.dart';

class BreakScreen extends StatefulWidget {
  // 1. Agregamos el parámetro para los minutos de descanso dinámicos
  final int breakMinutes;

  // Le asignamos 5 por defecto por si se llega a llamar sin parámetros
  const BreakScreen({
    super.key, 
    this.breakMinutes = 5,
  });

  @override
  State<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  // Ya no dejamos el valor fijo de 300, lo inicializamos en el initState
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 2. Convertimos los minutos de descanso dinámicos a segundos totales
    _secondsRemaining = widget.breakMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _showBreakFinishedDialog();
        }
      });
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showBreakFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Descanso Terminado! 🌟'),
        content: const Text('Tu mente está fresca y lista para continuar.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.of(context).pop(); // Regresa al Timer o Home
            },
            child: const Text('Volver a Estudiar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.15), // Usamos el color verde menta de fondo
      appBar: AppBar(
        title: const Text('Momento de Respirar 🍃'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Quita la flecha de atrás para obligar a descansar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono zen animado o estático
            Icon(
              Icons.spa, 
              size: 100, 
              color: Theme.of(context).colorScheme.secondary
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Inhala profundamente por la nariz...\nRetén... y exhala suavemente.',
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Reloj de descanso
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            // Botón para saltarse el descanso si de plano urge
            TextButton.icon(
              onPressed: () {
                _timer?.cancel();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.skip_next),
              label: const Text('Saltar Descanso'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}