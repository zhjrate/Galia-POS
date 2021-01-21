class Ticket {
  String orderName;
  List<TicketItem> items;
  String paymentType;
  int subtotal;
  int discounts;
  int total;

  Ticket({this.orderName, this.items, this.paymentType, this.subtotal, this.discounts, this.total});

}

class TicketItem {
  String itemName;
  int itemPrice;
  int itemQty;

  TicketItem({this.itemName, this.itemPrice, this.itemQty});

}