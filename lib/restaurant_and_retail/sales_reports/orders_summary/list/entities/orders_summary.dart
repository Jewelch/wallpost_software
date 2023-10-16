import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/entities/payment_mode.dart';

class OrdersSummary {
  late List<Order> orders;
  late String total;

  OrdersSummary.fromJson(Map<String, dynamic> json) {
    orders = (json['orders'] as List).map((e) => Order.fromJson(e)).toList();
    total = json['summary']['total'];
  }
}

class Order {
  late final int id;
  late final String num;
  late final String total;
  late final String date;
  late final String time;
  late final List<PaymentMode> paymentMode;
  late final String type;
  late final String user;

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    num = json['num'];
    total = json['total'];
    date = json['date'];
    time = json['time'];
    paymentMode = (json['payment_mode'] as List).map((e) => PaymentMode.fromJson(e)).toList();
    type = json['type'];
    user = json['user'];
  }

  String get paymentsString {
    if (paymentMode.isEmpty) return "";
    if (paymentMode.length == 1) {
      return paymentMode.first.methodName.capitalize();
    }
    var string = paymentMode.first.methodName.capitalize();
    for (var i = 1; i < paymentMode.length; i++) {
      string += "/${(paymentMode[i].methodName.capitalize())}";
    }
    return string;
  }
}

