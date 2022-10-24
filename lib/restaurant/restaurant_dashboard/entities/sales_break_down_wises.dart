enum SalesBreakDownWises {
  baseOnOrder,
  baseOnCategory,
  baseOnMenu;

  String toReadableString() {
    switch (this) {
      case SalesBreakDownWises.baseOnOrder:
        return "Order type wise";
      case SalesBreakDownWises.baseOnCategory:
        return "Category type wise";
      case SalesBreakDownWises.baseOnMenu:
        return "Menu type wise";
    }
  }

  String toRawString() {
    switch (this) {
      case SalesBreakDownWises.baseOnOrder:
        return "order_type";
      case SalesBreakDownWises.baseOnCategory:
        return "category";
      case SalesBreakDownWises.baseOnMenu:
        return "menu_item";
    }
  }
}
