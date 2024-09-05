/// A library for detecting and recognizing gesture patterns.
///
/// This library provides functionality to detect and recognize gesture
/// patterns, such as Morse code-like sequences of taps, long presses, and swipes.
/// It includes the following components:
///
/// - [GesturePattern] for defining gesture patterns.
/// - [GesturePatternRecognizer] for recognizing and processing gestures based on a pattern.
/// - [GesturePatternDetector] widget for integrating gesture pattern recognition into Flutter applications.
///
/// Example usage:
///
/// ```dart
/// import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';
///
/// GesturePatternDetector(
///   pattern: GesturePattern.parse('>.-<'),  // Define the gesture pattern
///   onPattern: () {
///     print('Pattern matched!');
///   },
///   child: YourWidget(),  // Widget to wrap and detect gestures on
///   timeout: Duration(seconds: 10),  // Optional timeout for pattern completion
/// );
/// ```
library gesture_pattern_detector;

import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';

export 'detector.dart';
export 'pattern.dart';
export 'recognizer.dart';
