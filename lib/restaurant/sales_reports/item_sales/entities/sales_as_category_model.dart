class SalesAsCategoriesModel {
  int? categoryId;
  String? categoryName;
  num? totalQuantity;
  num? totalRevenue;

  SalesAsCategoriesModel._({
    this.categoryId,
    this.categoryName,
    this.totalQuantity,
    this.totalRevenue,
  });

  factory SalesAsCategoriesModel.fromJson(Map<String, dynamic> json) => SalesAsCategoriesModel._(
        categoryId: json["categoryId"] as int,
        categoryName: json["categoryName"],
        totalQuantity: json["totalQuantity"],
        totalRevenue: json["totalRevenue"],
      );
}
