class Sales {
  String account;
  DateTime date;
  double discount;
  double tax;
  List<SoldItems> soldItems;
  String orderName;
  String orderID;
  double subTotal;
  double total;
  String paymentType;

  Sales(
      {this.account,
      this.date,
      this.discount,
      this.tax,
      this.soldItems,
      this.orderName,
      this.orderID,
      this.subTotal,
      this.total,
      this.paymentType});
}

class SoldItems {
  String product;
  String category;
  double price;
  int qty;
  double total;

  SoldItems({this.product, this.category, this.price, this.qty, this.total});
}
