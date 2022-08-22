import 'dart:io';

extension FileExtension on File {
  String name() {
    return absolute.path.substring(absolute.path.lastIndexOf("/") + 1);
  }
}
