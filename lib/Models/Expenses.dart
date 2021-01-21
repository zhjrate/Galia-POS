class Expenses {

  DateTime date;
  String costType;
  String account;
  String category;
  String vendor;
  String product;
  double price;
  int qty;
  double total;
  String paymentType;

  Expenses({this.date, this.costType, this.qty, this.total, this.category, this.vendor, this.paymentType, this.account, this.product, this.price});

}