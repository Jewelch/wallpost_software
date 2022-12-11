class SalesAsCategoryAndItem {
  SalesAsCategoryAndItem({
    this.data,
  });

  List<dynamic>? data;

  factory SalesAsCategoryAndItem.fromJson(Map<String, dynamic> json) => SalesAsCategoryAndItem(
        data: json["data"] == null ? null : List<dynamic>.from(json["data"].map((x) => x)),
      );
}

class PurpleDatum {
  PurpleDatum({
    this.categoryId,
    this.categoryName,
    this.items,
    this.totalQuantity,
    this.totalRevenue,
  });

  int? categoryId;
  String? categoryName;
  List<Item>? items;
  int? totalQuantity;
  double? totalRevenue;

  factory PurpleDatum.fromJson(Map<String, dynamic> json) => PurpleDatum(
        categoryId: json["categoryId"] == null ? null : json["categoryId"],
        categoryName: json["categoryName"] == null ? null : json["categoryName"],
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        totalQuantity: json["totalQuantity"] == null ? null : json["totalQuantity"],
        totalRevenue: json["totalRevenue"] == null ? null : json["totalRevenue"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId == null ? null : categoryId,
        "categoryName": categoryName == null ? null : categoryName,
        "items": items == null ? null : List<dynamic>.from(items!.map((x) => x.toJson())),
        "totalQuantity": totalQuantity == null ? null : totalQuantity,
        "totalRevenue": totalRevenue == null ? null : totalRevenue,
      };
}

class Item {
  Item({
    this.itemId,
    this.itemName,
    this.qty,
    this.revenue,
  });

  int? itemId;
  String? itemName;
  int? qty;
  double? revenue;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["itemId"] == null ? null : json["itemId"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        qty: json["qty"] == null ? null : json["qty"],
        revenue: json["revenue"] == null ? null : json["revenue"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId == null ? null : itemId,
        "item_name": itemName == null ? null : itemName,
        "qty": qty == null ? null : qty,
        "revenue": revenue == null ? null : revenue,
      };
}

class FluffyDatum {
  FluffyDatum({
    this.totalRevenue,
    this.totalQuantity,
  });

  double? totalRevenue;
  int? totalQuantity;

  factory FluffyDatum.fromJson(Map<String, dynamic> json) => FluffyDatum(
        totalRevenue: json["totalRevenue"] == null ? null : json["totalRevenue"].toDouble(),
        totalQuantity: json["totalQuantity"] == null ? null : json["totalQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "totalRevenue": totalRevenue == null ? null : totalRevenue,
        "totalQuantity": totalQuantity == null ? null : totalQuantity,
      };
}
