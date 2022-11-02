enum SalesBreakDownWiseOptions {
  basedOnOrder,
  basedOnCategory,
  basedOnMenu;

  String toReadableString() {
    switch (this) {
      case basedOnOrder:
        return "Order wise";
      case basedOnCategory:
        return "Category type wise";
      case basedOnMenu:
        return "Menu type wise";
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
