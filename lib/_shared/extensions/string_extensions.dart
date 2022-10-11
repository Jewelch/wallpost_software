extension ToSnakeCase on String {
  String get toSnakeCase => this == 'Custom' ? 'date' : replaceAll(' ', '_').toLowerCase();
}
