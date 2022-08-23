import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String yyyyMMddString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  // ignore: non_constant_identifier_names
  String HHmmssString() {
    return DateFormat('HH:mm:ss').format(this);
  }

  // ignore: non_constant_identifier_names
  String HHmmString() {
    return DateFormat('HH:mm').format(this);
  }
}

extension TimeExtension on TimeOfDay {
  // ignore: non_constant_identifier_names
  String HHmmString() {
    return "${this.hour.toString().padLeft(2, "0")}:${this.minute.toString().padLeft(2, "0")}";
  }

  String hhmmaString() {
    DateTime date = DateFormat("HH:mm").parse("${this.hour}:${this.minute}");
    return DateFormat("hh:mm a").format(date);
  }
}
