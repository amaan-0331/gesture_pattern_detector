# Gesture Pattern Detector

A Flutter plugin that allows you to detect custom gesture patterns using a Morse code-like string. The plugin supports taps, long presses, and swipes to create complex gesture sequences.

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## Features

- Recognizes patterns based on taps, long presses, and swipes.
- Customizable timeout for completing the gesture pattern.
- Callback function triggered upon successful pattern detection.

## Installation

Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  gesture_pattern_detector: any
```

Run `flutter pub get` to install the package.

## Usage

Wrap your widget with `GesturePatternDetector` and specify the pattern and callback.

### Example

```dart
import 'package:flutter/material.dart';
import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Gesture Pattern Detector')),
        body: GesturePatternDetector(
          // Define your pattern here
          // pattern: GesturePattern([GestureType.tap,GestureType.long,GestureType.tap]),
          pattern: GesturePattern.parse('><.-'),
          onPattern: () {
            print('Pattern matched!');
            // Action to run when pattern is matched
          },
          child: Container(
            color: Colors.blue,
            height: 200,
            width: 400,
            child: Center(child: Text('Tap or Swipe')),
          ),
        ),
      ),
    );
  }
}
```

## Pattern Syntax

- `.`: Tap
- `-`: Long press
- `>`: Swipe right
- `<`: Swipe left

## Parameters

- `pattern` (GesturePattern): The gesture pattern to match, using the syntax described above.
- `onPattern` (VoidCallback): The callback function to execute when the pattern is successfully matched.
- `child` (Widget): The widget to wrap with the gesture detector.
- `timeout` (Duration, optional): Time allowed to complete the pattern before it resets (default is 5 seconds).

## API

### GesturePatternDetector

```dart
class GesturePatternDetector extends StatefulWidget {
  final GesturePattern pattern;
  final VoidCallback onPattern;
  final Widget child;
  final Duration timeout;

  const GesturePatternDetector({
    required this.pattern,
    required this.onPattern,
    required this.child,
    this.timeout = const Duration(seconds: 5),
    super.key,
  });

  @override
  State<GesturePatternDetector> createState() => _GesturePatternDetectorState();
}
```

## Contributing

Contributions are welcome! Please follow the standard Flutter contribution guidelines.

## License

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
