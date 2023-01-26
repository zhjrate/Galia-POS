class ScheduledSales {
  String orderName;
  double subTotal;
  double total;
  double tax;
  double discount;
  List orderDetail;
  String id;
  DateTime savedDate;
  DateTime dueDate;
  Map client;
  double initialPayment;
  double remainingBalance;
  bool pending;
  String note;

  ScheduledSales(
      {this.orderName,
      this.subTotal,
      this.total,
      this.tax,
      this.discount,
      this.orderDetail,
      this.id,
      this.dueDate,
      this.savedDate,
      this.client,
      this.initialPayment,
      this.remainingBalance,
      this.pending,
      this.note});
}
