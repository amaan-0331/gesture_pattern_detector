import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _parsedPattern = GesturePattern.parse('.----.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gesture Pattern Detector')),
      body: Column(
        children: [
          Center(
            child: TextFormField(
              style: const TextStyle(fontSize: 75),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              initialValue: _parsedPattern.toString(),
              onChanged: (value) {
                setState(() {
                  try {
                    _parsedPattern = GesturePattern.parse(value);
                    debugPrint('Pattern updated: $_parsedPattern');
                  } catch (e) {
                    debugPrint('Error parsing pattern: $e');
                  }
                });
              },
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[><.\-]')),
              ],
            ),
          ),
          Expanded(
            child: GesturePatternDetector(
              pattern: const GesturePattern([GestureType.tap]),
              onPattern: () => FocusScope.of(context).unfocus(),
              child: Center(
                child: GesturePatternDetector(
                  onPattern: _success,
                  pattern: _parsedPattern,
                  behavior: HitTestBehavior.translucent,
                  child: const Text(
                    'Interact with me!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _success() {
    debugPrint('Pattern matched!');
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 100,
        spread: 70,
        y: 0.6,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Success!')),
    );
  }
}
