class Mocks {
  static Map<String, dynamic> purchaseBillDetailResponse = {
    "bill_id": 2271,
    "bill_to": "testsupp",
    "bill_no": "22/00089",
    "due_date": "2022-11-02",
    "currency": "EGP",
    "app_type": "billRequest",
    "items": [
      {
        "item_name": "abcd",
        "description": "",
        "quantity": "10",
        "price": 30,
        "amount": "300.00",
        "uom": "Kilogram",
        "discount": 0
      }
    ],
    "expenses": [],
    "summary": {
      "items_total": "300.00",
      "expenses_total": "0.00",
      "sub_total": "300.00",
      "total_discount": "0.00",
      "grandtotal_discount": "0.00",
      "total": "357.60",
      "taxes": [
        {
          "type": "VAT",
          "amount": 57
        },
        {
          "type": "Stamp Duty",
          "amount": 0.6
        }
      ]
    }
  };
}
