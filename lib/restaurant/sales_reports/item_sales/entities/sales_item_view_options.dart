enum SalesItemWiseOptions {
  CategoriesAndItems,
  CategoriesOnly,
  itemsOnly;

  String toReadableString() {
    switch (this) {
      case CategoriesOnly:
        return "Category item wise";
      case CategoriesAndItems:
        return "Category wise";
      case itemsOnly:
        return "Menu wise";
    }
  }

  String toRawString() {
    switch (this) {
      case CategoriesOnly:
        return "category_wise";
      case CategoriesAndItems:
        return "category_item_wise";
      case itemsOnly:
        return "menu_item_wise";
    }
  }
}
