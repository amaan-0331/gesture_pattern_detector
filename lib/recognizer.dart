import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gesture_pattern_detector/pattern.dart';

/// Core class to recognize a gesture pattern based on a Morse code-like string.
///
/// This class processes gestures and matches them against a predefined
/// sequence of gestures (`pattern`). If the gestures match the pattern
/// within the specified timeout, the [onPatternMatched] callback is invoked.
class GesturePatternRecognizer {
  /// Creates a [GesturePatternRecognizer] with the given [pattern], [timeout],
  /// and [onPatternMatched] callback.
  ///
  /// [pattern] is the sequence of gestures to recognize.
  /// [timeout] is the duration within which the pattern should be completed.
  /// [onPatternMatched] is the callback to be invoked when the pattern is matched.
  GesturePatternRecognizer({
    required this.pattern,
    required this.timeout,
    required this.onPatternMatched,
  }) {
    _gestureSequence = pattern.pattern;
  }

  /// The gesture pattern to recognize.
  final GesturePattern pattern;

  /// The duration within which the pattern must be completed.
  final Duration timeout;

  /// The callback to be invoked when the pattern is successfully matched.
  final VoidCallback onPatternMatched;

  /// The list of gestures that make up the pattern sequence.
  late List<GestureType> _gestureSequence;

  /// The index of the current gesture being matched in the sequence.
  int _currentIndex = 0;

  /// Timer used to enforce the pattern completion timeout.
  Timer? _timer;

  /// The stopwatch used to measure the elapsed time for the pattern.
  final Stopwatch _stopwatch = Stopwatch();

  /// Resets the pattern matching process and cancels the current timer.
  ///
  /// This method should be called when a mismatch occurs or when the pattern
  /// needs to be restarted.
  void resetPattern() {
    _currentIndex = 0;
    _timer?.cancel();
    _stopwatch.reset();
  }

  /// Checks if the current time is within the allowed time frame for the pattern.
  ///
  /// Returns `true` if the time elapsed since the start of the pattern is within
  /// the specified [timeout], otherwise returns `false`.
  bool _isWithinTimeFrame() {
    return _stopwatch.elapsed <= timeout;
  }

  /// Starts the stopwatch and timer to enforce the pattern completion timeout.
  ///
  /// This method records the start time and initializes the timer to call
  /// [resetPattern] when the timeout period elapses.
  void _startTimer() {
    _stopwatch.start();
    _timer = Timer(timeout, resetPattern);
  }

  /// Processes an incoming gesture and matches it against the pattern sequence.
  ///
  /// If the gesture matches the current expected gesture in the sequence, the
  /// [GesturePatternRecognizer] advances to the next gesture. If the pattern
  /// is completed successfully within the timeout, the [onPatternMatched] callback
  /// is invoked. If there is a mismatch or the time frame is exceeded, the pattern
  /// is reset.
  ///
  /// [gesture] is the gesture to process and match against the pattern.
  void processGesture(GestureType gesture) {
    if (_currentIndex == 0) {
      _startTimer();
    } else if (!_isWithinTimeFrame()) {
      resetPattern();
      return;
    }

    if (_gestureSequence[_currentIndex] == gesture) {
      _currentIndex++;

      if (_currentIndex == _gestureSequence.length) {
        onPatternMatched();
        resetPattern();
      }
    } else {
      resetPattern();
    }
  }
}
