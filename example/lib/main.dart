import 'package:flutter/material.dart';
import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GesturePatternDetector(
            onPattern: () {
              debugPrint('success');
            },
            pattern: GesturePattern.parse('><.-'),
            child: const Text(
              'Interact with me!',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
