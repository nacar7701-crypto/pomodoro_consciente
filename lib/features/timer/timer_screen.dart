import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_consciente/features/break_guide/break_screen.dart';

class TimerScreen extends StatefulWidget {
  final String materia;
  final String objetivo;

  const TimerScreen({
    super.key,
    required this.materia,
    required this.objetivo,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState(); 
}

class _TimerScreenState extends State<TimerScreen> {
  // 25 minutos por defecto en segundos (25 * 60 = 1500)
  int _secondsRemaining = 1500; 
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;
    
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          // TODO: Lanzar alarma e ir a descanso guiado
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BreakScreen()),
          );
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 1500;
      _isRunning = false;
    });
  }

  // Convierte los segundos totales a formato MM:SS
  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Evita fugas de memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materia),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Objetivo: ${widget.objetivo}',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            
            // Reloj Gigante
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            // Botones de control
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, size: 36),
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: 24),
                FloatingActionButton.large(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.stop, size: 36),
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.pop(context); // Regresa a la Home
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}