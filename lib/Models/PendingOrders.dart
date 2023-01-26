class PendingOrders {
  String orderName;
  String address;
  int phone;
  int total;
  String paymentType;
  List orderDetail;
  DateTime orderDate;
  String docID;

  PendingOrders(
      {this.orderName,
      this.total,
      this.address,
      this.phone,
      this.paymentType,
      this.orderDetail,
      this.orderDate,
      this.docID});
}
