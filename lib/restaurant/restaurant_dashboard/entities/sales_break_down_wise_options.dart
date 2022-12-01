enum SalesBreakDownWiseOptions {
  basedOnCategory,
  basedOnOrder,
  basedOnMenu;

  String toReadableString() {
    switch (this) {
      case basedOnOrder:
        return "Order";
      case basedOnCategory:
        return "Category";
      case basedOnMenu:
        return "Menu";
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
