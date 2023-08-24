import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class PayablesItem {
  late final String period;
  late final String overdue;
  late final String due;

  PayablesItem.fromJson(String periodKey, Map<String, dynamic> json) {
    try {
      period = periodKey;
      overdue = json['overdue'];
      due = json['due'];
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast PayablesItem response. Error message - $error');
    }
  }
}

class PayablesData {
  late final String totalOverDuw;
  late final String totalDue;
  late final List<PayablesItem> items;

  PayablesData.fromJson(Map<String, dynamic> json) {
    try {
      totalOverDuw = json['totalOverdue'];
      totalDue = json['totalDue'];
      items = [];
      (json['table'] as Map).forEach((key, value) {
        items.add(PayablesItem.fromJson(key, value));
      });
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast PayablesData response. Error message - $error');
    }
  }
}
