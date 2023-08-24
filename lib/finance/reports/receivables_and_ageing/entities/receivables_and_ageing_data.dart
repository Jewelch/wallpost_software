import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class ReceivableItem {
  late final String period;
  late final String overdue;
  late final String due;

  ReceivableItem.fromJson(String periodKey, Map<String, dynamic> json) {
    try {
      period = periodKey;
      overdue = json['overdue'];
      due = json['due'];
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast ReceivableItem response. Error message - $error');
    }
  }
}

class ReceivablesData {
  late final String totalOverDuw;
  late final String totalDue;
  late final List<ReceivableItem> items;

  ReceivablesData.fromJson(Map<String, dynamic> json) {
    try {
      totalOverDuw = json['totalOverdue'];
      totalDue = json['totalDue'];
      items = [];
      (json['table'] as Map).forEach((key, value) {
        items.add(ReceivableItem.fromJson(key, value));
      });
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast ReceivablesData response. Error message - $error');
    }
  }
}
