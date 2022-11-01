extension StringExtensions on String {
  double get toDouble => double.tryParse(this) ?? 0;
  String get withoutNullDecimals => replaceAll('.00', '');
  String get commaSeparated => replaceAll('.', ',');
  bool get isNegative => (num.tryParse(this) ?? 0).isNegative;
}
