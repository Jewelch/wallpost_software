import 'dart:ui';

extension ColorExtension on Color {
  bool isEqualTo(Color anotherColor) {
    return this.red == anotherColor.red &&
        this.green == anotherColor.green &&
        this.blue == anotherColor.blue &&
        this.alpha == anotherColor.alpha;
  }
}
