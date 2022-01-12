import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  String yyyyMMddString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  // ignore: non_constant_identifier_names
  String HHmmssString() {
    return DateFormat('HH:mm:ss').format(this);
  }
}
