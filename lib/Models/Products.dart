class Products {
  String product;
  int price;
  String image;
  String category;
  String description;
  List<PriceOptions> priceOptions;
  bool available;
  bool milkOptions;
  String productID;

  Products(
      {this.product,
      this.price,
      this.image,
      this.description,
      this.category,
      this.priceOptions,
      this.available,
      this.milkOptions,
      this.productID});
}

class PriceOptions {
  String option;
  double price;

  PriceOptions(this.option, this.price);
}
