// ignore_for_file: public_member_api_docs, sort_constructors_first
class GesturePattern {
  //
  final List<GestureType> pattern;

  GesturePattern(
    this.pattern,
  );

  factory GesturePattern.parse(String sequence) {
    // Parse the pattern string into a GestureType list
    return GesturePattern(sequence.split('').map((char) {
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
    }).toList());
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
