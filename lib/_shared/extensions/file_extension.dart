import 'dart:io';

import 'package:path/path.dart';

extension FileExtension on File {
  String name() {
    return basename(path);
  }
}
