import 'package:flutter/gestures.dart';
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

    // default
    this.behavior,
    this.supportedDevices,
    this.excludeFromSemantics = false,
    this.trackpadScrollCausesScale = false,
    this.dragStartBehavior = DragStartBehavior.start,
    this.trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
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

  // default

  /// How this gesture detector should behave during hit testing when deciding
  /// how the hit test propagates to children and whether to consider targets
  /// behind this one.
  ///
  /// This defaults to [HitTestBehavior.deferToChild] if [child] is not null and
  /// [HitTestBehavior.translucent] if child is null.
  ///
  /// See [HitTestBehavior] for the allowed values and their meanings.
  final HitTestBehavior? behavior;

  /// Whether to exclude these gestures from the semantics tree. For
  /// example, the long-press gesture for showing a tooltip is
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], gesture drag behavior will
  /// begin at the position where the drag gesture won the arena. If set to
  /// [DragStartBehavior.down] it will begin at the position where a down event
  /// is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// Only the [DragGestureRecognizer.onStart] callbacks for the
  /// [VerticalDragGestureRecognizer], [HorizontalDragGestureRecognizer] and
  /// [PanGestureRecognizer] are affected by this setting.
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  /// The kind of devices that are allowed to be recognized.
  ///
  /// If set to null, events from all device types will be recognized. Defaults to null.
  final Set<PointerDeviceKind>? supportedDevices;

  /// {@macro flutter.gestures.scale.trackpadScrollCausesScale}
  final bool trackpadScrollCausesScale;

  /// {@macro flutter.gestures.scale.trackpadScrollToScaleFactor}
  final Offset trackpadScrollToScaleFactor;

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
      key: widget.key,
      behavior: widget.behavior,
      dragStartBehavior: widget.dragStartBehavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      supportedDevices: widget.supportedDevices,
      trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
      trackpadScrollToScaleFactor: widget.trackpadScrollToScaleFactor,
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
