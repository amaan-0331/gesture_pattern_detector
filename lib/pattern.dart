import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// Represents a pattern of gestures.
@immutable
class GesturePattern {
  /// Creates a [GesturePattern] with the given list of [GestureType]s.
  ///
  /// [pattern] can be empty, which represents no specific pattern.
  const GesturePattern(this.pattern);

  /// Parses a string sequence into a [GesturePattern].
  ///
  /// The [sequence] string should contain characters representing different
  /// gesture types:
  ///
  /// * `.` for [GestureType.tap]
  /// * `-` for [GestureType.long]
  /// * `>` for [GestureType.rightSwipe]
  /// * `<` for [GestureType.leftSwipe]
  ///
  /// Throws an [ArgumentError] if the [sequence] contains invalid characters.
  factory GesturePattern.parse(String sequence) {
    return GesturePattern(
      sequence.split('').map((char) {
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
      }).toList(),
    );
  }

  /// The list of gestures that make up this pattern.
  final List<GestureType> pattern;

  /// Converts the [GesturePattern] to a string representation.
  ///
  /// Example:
  /// If the pattern is `[GestureType.rightSwipe, GestureType.leftSwipe, GestureType.tap, GestureType.long]`,
  /// calling `toString()` will return `><.-`.
  @override
  String toString() {
    return pattern.map((gestureType) => gestureType.string).join();
  }

  @override
  bool operator ==(Object other) {
    // Check if the other object is of type GesturePattern
    if (identical(this, other)) return true;
    if (other is! GesturePattern) return false;

    // Compare the pattern lists for deep equality
    return const DeepCollectionEquality().equals(pattern, other.pattern);
  }

  @override
  int get hashCode {
    // Compute a hash code based on the pattern list
    return const DeepCollectionEquality().hash(pattern);
  }
}

/// Enum representing different types of gestures.
enum GestureType {
  /// Represents a tap gesture.
  tap,

  /// Represents a long press gesture.
  long,

  /// Represents a right swipe gesture.
  rightSwipe,

  /// Represents a left swipe gesture.
  leftSwipe;

  /// Gets the string representation of the gesture type.
  ///
  /// The string representation is:
  /// * `.` for [GestureType.tap]
  /// * `-` for [GestureType.long]
  /// * `>` for [GestureType.rightSwipe]
  /// * `<` for [GestureType.leftSwipe]
  String get string => switch (this) {
        tap => '.',
        long => '-',
        rightSwipe => '>',
        leftSwipe => '<',
      };
}
