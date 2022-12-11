enum SalesItemWiseOptions {
  viewAsCategoryAndItem,
  viewAsCategory,
  viewAsItem;

  String toReadableString() {
    switch (this) {
      case viewAsCategory:
        return "Category item wise";
      case viewAsCategoryAndItem:
        return "Category wise";
      case viewAsItem:
        return "Menu wise";
    }
  }

  String toRawString() {
    switch (this) {
      case viewAsCategory:
        return "category_wise";
      case viewAsCategoryAndItem:
        return "category_item_wise";
      case viewAsItem:
        return "menu_item_wise";
    }
  }
}
