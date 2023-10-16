class PaymentMode {
  late final String methodName;
  late final String amount;

  PaymentMode.fromJson(Map<String, dynamic> json) {
    methodName = json['method_name'];
    amount = json['amount'];
  }
}
