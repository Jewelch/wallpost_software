class SalesAsItemModel {
  int? itemId;
  String? itemName;
  int? qty;
  int? revenue;

  SalesAsItemModel._({
    this.itemId,
    this.itemName,
    this.qty,
    this.revenue,
  });

  factory SalesAsItemModel.fromJson(Map<String, dynamic> json) => SalesAsItemModel._(
        itemId: json['itemId'],
        itemName: json['item_name'],
        qty: json['qty'],
        revenue: json['revenue'],
      );
}
