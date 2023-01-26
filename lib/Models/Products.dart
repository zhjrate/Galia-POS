class Products {
  String product;
  double price;
  String image;
  String category;
  String description;
  List<ProductOptions> productOptions;
  bool available;
  String productID;
  List historicPrices;
  String code;
  List ingredients;
  List searchName;
  bool vegan;
  bool showOnMenu;

  Products(
      {this.product,
      this.price,
      this.image,
      this.description,
      this.category,
      this.productOptions,
      this.available,
      this.productID,
      this.historicPrices,
      this.code,
      this.ingredients,
      this.searchName,
      this.vegan,
      this.showOnMenu});
}

class ProductOptions {
  String title;
  bool mandatory;
  bool multipleOptions;
  String priceStructure;
  List priceOptions;

  ProductOptions(this.title, this.mandatory, this.multipleOptions,
      this.priceStructure, this.priceOptions);
}

class PriceOptions {
  String option;
  double price;

  PriceOptions(this.option, this.price);
}
