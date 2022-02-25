import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  String yyyyMMddString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  // ignore: non_constant_identifier_names
  String HHmmssString() {
    return DateFormat('HH:mm:ss').format(this);
  }

  String HHmmString() {
    return DateFormat('HH:mm').format(this);
  }
}

extension TimeUtils on TimeOfDay {
  String HHmmssString() {
    return "${this.hour}:${this.minute}:00";
  }

  String HHmmString() {
    return "${this.hour}:${this.minute}";
  }
}
