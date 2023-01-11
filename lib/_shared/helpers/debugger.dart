import 'dart:developer';

class Debugger {
  Debugger._();

  static void black(String prefix, [String? text]) => log(
        '\x1B[30m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void red(String prefix, [String? text]) => log(
        '\x1B[31m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void green(String prefix, [String? text]) => log(
        '\x1B[32m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void yellow(String? prefix, [String? text]) => log(
        '\x1B[33m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void blue(String prefix, [String? text]) => log(
        '\x1B[34m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void magenta(String prefix, [String? text]) => log(
        '\x1B[35m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void cyan(String prefix, [String? text]) => log(
        '\x1B[36m$text\x1B[0m',
        name: ' $prefix ',
      );

  static void white(String prefix, [String? text]) => log(
        '\x1B[37m$text\x1B[0m',
        name: ' $prefix ',
      );
}
