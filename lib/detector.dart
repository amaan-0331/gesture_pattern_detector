import 'package:flutter/widgets.dart';
import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';

/// A widget that detects a Morse code-like gesture pattern.
///
/// This widget wraps another widget (`child`) and listens for user gestures.
/// It recognizes a pattern of gestures, such as taps, long presses, and swipes,
/// and triggers the [onPattern] callback when the specified pattern is successfully matched.
class GesturePatternDetector extends StatefulWidget {
  /// Creates a [GesturePatternDetector] widget.
  ///
  /// [pattern] is the gesture pattern to be detected.
  /// [onPattern] is the callback to be invoked when the pattern is successfully matched.
  /// [child] is the widget to be wrapped and monitored for gestures.
  /// [timeout] is the duration within which the pattern must be completed before it resets.
  /// The default timeout is 5 seconds.
  const GesturePatternDetector({
    required this.pattern,
    required this.onPattern,
    required this.child,
    this.timeout = const Duration(seconds: 5),
    super.key,
  });

  /// The gesture pattern to detect.
  ///
  /// The pattern uses:
  /// * `.` for [GestureType.tap]
  /// * `-` for [GestureType.long]
  /// * `>` for [GestureType.rightSwipe]
  /// * `<` for [GestureType.leftSwipe]
  final GesturePattern pattern;

  /// Callback invoked when the gesture pattern is successfully matched.
  final VoidCallback onPattern;

  /// The widget that will be wrapped with the gesture detector.
  final Widget child;

  /// The duration within which the gesture pattern must be completed.
  ///
  /// If the pattern is not completed within this time frame, it will reset.
  final Duration timeout;

  @override
  State<GesturePatternDetector> createState() => _GesturePatternDetectorState();
}

class _GesturePatternDetectorState extends State<GesturePatternDetector> {
  late GesturePatternRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _initializeRecognizer();
  }

  void _initializeRecognizer() {
    _recognizer = GesturePatternRecognizer(
      pattern: widget.pattern,
      timeout: widget.timeout,
      onPatternMatched: widget.onPattern,
    );
  }

  @override
  void didUpdateWidget(covariant GesturePatternDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pattern != oldWidget.pattern) {
      _updateRecognizerPattern();
    }
  }

  void _updateRecognizerPattern() {
    _recognizer.resetPattern();

    if (widget.pattern.pattern.isNotEmpty) {
      _recognizer = GesturePatternRecognizer(
        pattern: widget.pattern,
        timeout: widget.timeout,
        onPatternMatched: widget.onPattern,
      );
    }
  }

  @override
  void dispose() {
    _recognizer.resetPattern();
    super.dispose();
  }

  /// Handles a tap gesture by processing it with the recognizer.
  void _handleTap() {
    if (widget.pattern.pattern.isNotEmpty) {
      _recognizer.processGesture(GestureType.tap);
    }
  }

  /// Handles a long press gesture by processing it with the recognizer.
  void _handleLongPress() {
    if (widget.pattern.pattern.isNotEmpty) {
      _recognizer.processGesture(GestureType.long);
    }
  }

  /// Handles a swipe left gesture by processing it with the recognizer.
  void _handleSwipeLeft() {
    if (widget.pattern.pattern.isNotEmpty) {
      _recognizer.processGesture(GestureType.leftSwipe);
    }
  }

  /// Handles a swipe right gesture by processing it with the recognizer.
  void _handleSwipeRight() {
    if (widget.pattern.pattern.isNotEmpty) {
      _recognizer.processGesture(GestureType.rightSwipe);
    }
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
