import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String yyyyMMddString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String yMMMd() {
    return DateFormat('yMMMd').format(this);
  }

  // ignore: non_constant_identifier_names
  String HHmmssString() {
    return DateFormat('HH:mm:ss').format(this);
  }

  // ignore: non_constant_identifier_names
  String HHmmString() {
    return DateFormat('HH:mm').format(this);
  }

  String toReadableString() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String toReadableStringWithHyphens() {
    return DateFormat('dd-MMM-yyyy').format(this);
  }

  bool isDateAfter(DateTime otherDate) {
    if (_daysBetween(this, otherDate) < 0) return true;

    return false;
  }

  int daysBetween(DateTime otherDate) {
    return _daysBetween(this, otherDate);
  }

  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool isToday() {
    var today = DateTime.now();
    return this.year == today.year && this.month == today.month && this.day == today.day;
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
