import 'package:flutter/material.dart';

class KeyboardDismisser {
  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
