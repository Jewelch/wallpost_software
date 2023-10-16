import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/restaurant_and_retail/sales_reports/orders_summary/entities/payment_mode.dart';

class OrderDetails {
  late final Details details;
  late final List<OrderItems> orderItems;
  late final Summary summary;

  OrderDetails.fromJson(Map<String, dynamic> json) {
    details = Details.fromJson(json['order_details']);
    orderItems = (json['order_items'] as List).map((e) => OrderItems.fromJson(e)).toList();

    summary = Summary.fromJson(json['summary']);
  }
}

class Details {
  late final int id;
  late final String num;
  late final String total;
  late final String date;
  late final String time;
  late final List<PaymentMode> paymentMode;
  late final String type;
  late final String user;

  Details.fromJson(Map<String, dynamic> json) {
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

class OrderItems {
  late final int id;
  late final String name;
  late final String code;
  late final String price;
  late final String quantity;
  late final String total;

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    price = json['price'];
    quantity = json['quantity'];
    total = json['total'];
  }
}

class Summary {
  late final String total;
  late final String tax;
  late final String discount;
  late final String subTotal;

  num get discountPrice => _convertPrice(discount);
  num get taxPrice => _convertPrice(tax);

  num _convertPrice(String price) {
    return num.parse(price.replaceAll(",", "").replaceAll(".", ""));
  }

  Summary.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    tax = json['tax'];
    discount = json['discount'];
    subTotal = json['sub_total'];
  }
}
