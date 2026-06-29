import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_consciente/features/break_guide/break_screen.dart';
import 'package:pomodoro_consciente/main.dart'; 

class TimerScreen extends StatefulWidget {
  final String materia;
  final String objetivo;
  final int studyMinutes; 
  final int breakMinutes;

  const TimerScreen({
    super.key,
    required this.materia,
    required this.objetivo,
    required this.studyMinutes,
    required this.breakMinutes,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState(); 
}

class _TimerScreenState extends State<TimerScreen> {
  late int _secondsRemaining; 
  late int _totalSeconds; 
  Timer? _timer;
  bool _isRunning = false;
  bool _isBreak = false; 
  
  int _currentPomodoro = 1;
  final int _totalPomodoros = 4;
  String _selectedAmbience = 'Ninguno';

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.studyMinutes * 60;
    _secondsRemaining = _totalSeconds;
  }

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
          if (!_isBreak) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BreakScreen(breakMinutes: widget.breakMinutes),
              ),
            );
          }
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
      _secondsRemaining = _isBreak ? widget.breakMinutes * 60 : widget.studyMinutes * 60;
      _isRunning = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getMotivationalPhrase() {
    final minutesRemaining = _secondsRemaining / 60;
    if (_secondsRemaining == 0) return '🎉 ¡Excelente trabajo!';
    if (minutesRemaining <= 1) return '🔥 Último esfuerzo.';
    if (minutesRemaining <= 5) return '💪 Ya casi terminas este bloque.';
    return '🧠 Mantén la concentración.';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final stateColor = _isBreak ? colorScheme.tertiary : colorScheme.primary;
    final progressValue = _totalSeconds > 0 ? _secondsRemaining / _totalSeconds : 0.0;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 45,
        // 2. Agregamos el botón reactivo de cambio de tema en las acciones del AppBar
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, ThemeMode currentMode, __) {
              final isDark = currentMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro',
                onPressed: () {
                  themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              // 1. Materia
              Text(
                '📚 ${widget.materia}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              // 2. Tarjeta del Objetivo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.track_changes, color: stateColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Objetivo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.objetivo,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),

              // 3. Temporizador Circular
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 8,
                      backgroundColor: stateColor.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isBreak ? Icons.local_cafe : Icons.lens_blur,
                            size: 14,
                            color: stateColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isBreak ? 'Descanso' : 'Enfoque',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: stateColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // 4. Frase motivacional
              Text(
                _getMotivationalPhrase(),
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              // 5. Botones de Control
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 28),
                    onPressed: _resetTimer,
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton.large(
                    elevation: 2,
                    backgroundColor: stateColor,
                    foregroundColor: Colors.white,
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.stop, size: 28),
                    onPressed: () {
                      _timer?.cancel();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              // 6. Sección de Ambiente
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: ['Ninguno', 'Lluvia', 'Bosque', 'Café'].map((ambience) {
                      final isSelected = _selectedAmbience == ambience;
                      return ChoiceChip(
                        label: Text(ambience, style: const TextStyle(fontSize: 13)),
                        selected: isSelected,
                        selectedColor: stateColor.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        labelStyle: TextStyle(
                          color: isSelected ? stateColor : colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedAmbience = ambience;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),

              // 7. Contador inferior limpio
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🍅', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'Pomodoro $_currentPomodoro de $_totalPomodoros',
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withOpacity(0.8)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), 
            ],
          ),
        ),
      ),
    );
  }
}