class Tables {
  String table;
  String assignedOrder;
  bool isOpen;
  DateTime openSince;
  int numberOfPeople;
  //Saved
  int subTotal;
  int total;
  int tax;
  int discount;
  String paymentType;
  List orderDetail;
  int orderColor;
  Map client;

  Tables(
      {this.table,
      this.assignedOrder,
      this.isOpen,
      this.openSince,
      this.numberOfPeople,
      this.subTotal,
      this.total,
      this.tax,
      this.discount,
      this.paymentType,
      this.orderDetail,
      this.orderColor,
      this.client});
}
