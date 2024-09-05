import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gesture_pattern_detector/gesture_pattern_detector.dart';

const _testingWidget = MaterialApp(home: Text('Testing World!'));

void main() {
  testWidgets('Pattern is matched and triggers callback',
      (WidgetTester tester) async {
    var patternMatched = false;

    await tester.pumpWidget(
      GesturePatternDetector(
        pattern: GesturePattern.parse('.-'),
        onPattern: () {
          patternMatched = true;
        },
        child: _testingWidget,
      ),
    );

    // Simulate tap and long press according to pattern
    await tester.tap(find.byType(Text)); // Tap (.)
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(Text)); // Long press (-)
    await tester.pumpAndSettle();

    expect(patternMatched, isTrue); // Ensure callback is triggered
  });

  testWidgets('Pattern resets when gestures exceed timeout',
      (WidgetTester tester) async {
    var patternMatched = false;

    await tester.pumpWidget(
      GesturePatternDetector(
        pattern: GesturePattern.parse('.-'),
        timeout: const Duration(seconds: 2),
        onPattern: () {
          patternMatched = true;
        },
        child: _testingWidget,
      ),
    );

    // Simulate tap and long press with a delay that exceeds the timeout
    await tester.tap(find.byType(Text)); // Tap (.)
    await tester.pump(const Duration(seconds: 3)); // Exceed timeout

    await tester.longPress(find.byType(Text)); // Long press (-)
    await tester.pumpAndSettle();

    expect(patternMatched, isFalse); // Pattern should not match
  });

  testWidgets('Incorrect pattern does not trigger callback',
      (WidgetTester tester) async {
    var patternMatched = false;

    await tester.pumpWidget(
      GesturePatternDetector(
        pattern: GesturePattern.parse('.-'),
        onPattern: () {
          patternMatched = true;
        },
        child: _testingWidget,
      ),
    );

    // Simulate a wrong pattern (e.g., double tap instead of tap + long press)
    await tester.tap(find.byType(Text)); // Tap (.)
    await tester.tap(find.byType(Text)); // Another tap (incorrect)

    await tester.pumpAndSettle();

    expect(patternMatched, isFalse); // Callback should not be triggered
  });

  testWidgets('Partial pattern does not trigger callback',
      (WidgetTester tester) async {
    var patternMatched = false;

    await tester.pumpWidget(
      GesturePatternDetector(
        pattern: GesturePattern.parse('.-'),
        onPattern: () {
          patternMatched = true;
        },
        child: _testingWidget,
      ),
    );

    await tester.tap(find.byType(Text)); // Tap (.)
    await tester.pumpAndSettle();

    expect(patternMatched, isFalse);
  });
}
