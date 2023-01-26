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
  String clientName;
  Map clientDetails;
  String transactionID;
  String docID;
  String cashRegister;
  bool reversed;

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
      this.paymentType,
      this.clientName,
      this.clientDetails,
      this.transactionID,
      this.docID,
      this.cashRegister,
      this.reversed});
}

class SoldItems {
  String product;
  String category;
  double price;
  double qty;
  double total;

  SoldItems({this.product, this.category, this.price, this.qty, this.total});
}
