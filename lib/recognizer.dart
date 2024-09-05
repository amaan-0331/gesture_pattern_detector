import 'dart:async';

import 'package:flutter/widgets.dart';

/// Core class to recognize a gesture pattern based on a Morse code-like string
class GesturePatternRecognizer {
  final String pattern;
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
    // Parse the pattern string into a GestureType list
    _gestureSequence = pattern.split('').map((char) {
      switch (char) {
        case '.':
          return GestureType.tap;
        case '-':
          return GestureType.long;
        case '>':
          return GestureType.rightSwipe;
        case '<':
          return GestureType.leftSwipe;
        default:
          throw ArgumentError('Invalid pattern character: $char');
      }
    }).toList();
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

enum GestureType {
  tap,
  long,
  leftSwipe,
  rightSwipe;

  String get string => switch (this) {
        tap => '.',
        long => '-',
        rightSwipe => '>',
        leftSwipe => '<',
      };
}
