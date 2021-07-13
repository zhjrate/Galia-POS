import 'dart:async';

class TicketBloc {
  /// The [ticketStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final ticketStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => ticketStreamController.stream;

  /// The [ticketItems] Map would hold all the data this bloc provides
  final Map ticketItems = {
    'Order Name':'',
    'Payment Type': '',
    'Items': [],
    'Subtotal': 0,
    'Discount': 0,
    'IVA': 0,
    'Total': 0,
  };

  /// [retrieveOrder] removes items from the cart, back to the shop
  void retrieveOrder(orderName, paymentType, items, subtotal, discount, tax, total) {
    
    ticketItems['Order Name'] = orderName;
    ticketItems['Payment Type'] = paymentType;
    ticketItems['Items'] = items;
    ticketItems['Subtotal'] = subtotal;
    ticketItems['Discount'] = discount;
    ticketItems['IVA'] = tax;
    ticketItems['Total'] = total;
    

    ticketStreamController.sink.add(ticketItems);
  }
  
  
  /// [changeOrderName] removes items from the cart, back to the shop
  void changeOrderName(orderName) {
    ticketItems['Order Name'] = orderName;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [addToCart] adds items from the shop to the cart
  void addToCart(item) {
    ticketItems['Items'].add(item);
    ticketStreamController.sink.add(ticketItems);
  }

  /// [removeFromCart] removes items from the cart, back to the shop
  void removeFromCart(item) {
    ticketItems['Items'].remove(item);
    ticketStreamController.sink.add(ticketItems);
  }

  /// [removeAllFromCart] removes items from the cart, back to the shop
  void removeAllFromCart() {
    ticketItems['Order Name'] = '';
    ticketItems['Payment Type'] = '';
    ticketItems['Items'] = [];
    ticketItems['Subtotal'] = 0;
    ticketItems['Discount'] = 0;
    ticketItems['Total'] = 0;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [addQuantity] removes items from the cart, back to the shop
  void addQuantity(i) {
    ticketItems['Items'][i]['Quantity'] = ticketItems['Items'][i]['Quantity'] + 1;
    ticketItems['Items'][i]['Total Price'] = ticketItems['Items'][i]['price'] * ticketItems['Items'][i]['Quantity'];
    
    ticketStreamController.sink.add(ticketItems);

  }

  /// [removeQuantity] removes items from the cart, back to the shop
  void removeQuantity(i) {
    ticketItems['Items'][i]['Quantity'] = ticketItems['Items'][i]['Quantity'] - 1;
    ticketItems['Items'][i]['Total Price'] = ticketItems['Items'][i]['price'] * ticketItems['Items'][i]['Quantity'];
    
    ticketStreamController.sink.add(ticketItems);
  }

  /// The [dispose] method is used 
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    ticketStreamController.close(); // close our StreamController
  }

}


final bloc = TicketBloc();  // add to the end of the file