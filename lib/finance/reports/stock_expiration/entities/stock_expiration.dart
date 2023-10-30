
class StockExpiration {
  final int id;
  final String name;
  final String code;
  final String category;
  final String expireDate;
  final String stock;

  StockExpiration.fromJson(Map<String, dynamic> json)
      : id = json['item_id'],
        name = json['item_name'],
        code = json['item_code'],
        category = json['cat_name'],
        expireDate = json['expiry_date'].toString().split(" ")[0],
        stock = json['stock'].toString().split(" ")[0];
}
   