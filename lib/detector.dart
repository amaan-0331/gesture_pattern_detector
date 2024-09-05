import 'package:flutter/material.dart';
import 'package:gesture_pattern_detector/recognizer.dart';

/// A widget that detects a Morse code-like gesture pattern
class GesturePatternDetector extends StatefulWidget {
  /// The pattern string, where '.' = tap, '-' = long press
  final String pattern;

  /// Callback when the pattern is successfully matched
  final VoidCallback onPattern;

  /// The widget to wrap with the detector
  final Widget child;

  /// Time in seconds to complete the pattern before it resets
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

class _GesturePatternDetectorState extends State<GesturePatternDetector> {
  late GesturePatternRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = GesturePatternRecognizer(
      pattern: widget.pattern,
      timeout: widget.timeout,
      onPatternMatched: widget.onPattern,
    );
  }

  void _handleTap() {
    _recognizer.processGesture(GestureType.tap);
  }

  void _handleLongPress() {
    _recognizer.processGesture(GestureType.long);
  }

  void _handleSwipeLeft() {
    _recognizer.processGesture(GestureType.leftSwipe);
  }

  void _handleSwipeRight() {
    _recognizer.processGesture(GestureType.rightSwipe);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _handleSwipeRight();
        } else if (details.primaryVelocity! < 0) {
          _handleSwipeLeft();
        }
      },
      child: widget.child,
    );
  }
}
