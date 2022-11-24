enum SalesBreakDownWiseOptions {
  basedOnCategory,
  basedOnOrder,
  basedOnMenu;

  String toReadableString() {
    switch (this) {
      case basedOnOrder:
        return "Order wise";
      case basedOnCategory:
        return "Category wise";
      case basedOnMenu:
        return "Menu wise";
    }
  }

  String toRawString() {
    switch (this) {
      case basedOnOrder:
        return "order_type";
      case basedOnCategory:
        return "category";
      case basedOnMenu:
        return "menu_item";
    }
  }
}
