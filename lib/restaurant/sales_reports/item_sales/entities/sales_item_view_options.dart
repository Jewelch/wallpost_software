enum SalesItemWiseOptions {
  CategoriesAndItems,
  CategoriesOnly,
  itemsOnly;

  String toReadableString() {
    switch (this) {
      case CategoriesOnly:
        return "Category wise";
      case CategoriesAndItems:
        return "Category & Item wise";
      case itemsOnly:
        return "Item wise";
    }
  }

}
