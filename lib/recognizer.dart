import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gesture_pattern_detector/pattern.dart';

/// Core class to recognize a gesture pattern based on a Morse code-like string
class GesturePatternRecognizer {
  final GesturePattern pattern;
  final Duration timeout;
  final VoidCallback onPatternMatched;
  late List<GestureType> _gestureSequence;

  int _currentIndex = 0;
  Timer? _timer;
  late DateTime _startTime;

  GesturePatternRecognizer({
    required this.pattern,
    required this.timeout,
    required this.onPatternMatched,
  }) {
    _gestureSequence = pattern.pattern;
  }

  void resetPattern() {
    _currentIndex = 0;
    _timer?.cancel();
  }

  bool _isWithinTimeFrame() {
    return DateTime.now().difference(_startTime).inSeconds <= timeout.inSeconds;
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer(timeout, resetPattern);
  }

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
