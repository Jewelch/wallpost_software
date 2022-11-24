extension StringExtensions on String {
  double get toDouble => double.tryParse(this) ?? 0;

  bool get isNegative => (num.tryParse(this) ?? 0).isNegative;

  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
