import 'dart:async';
import 'package:flutter/material.dart';

class TicketBloc {
  /// The [ticketStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final ticketStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => ticketStreamController.stream;

  /// The [ticketItems] Map would hold all the data this bloc provides
  final Map ticketItems = {
    'Order Name': '',
    'Payment Type': '',
    'Items': [],
    'Subtotal': 0,
    'Discount': 0,
    'IVA': 0,
    'Total': 0,
    'Color': Colors.white,
    'Open Table': false,
    'Order ID': '',
    'Counter Order': false,
    'Order Type': 'Mostrador',
    'Client Assigned': false,
    'Client': {
      'Name': '',
      'Address': '',
      'Phone': 0,
      'email': '',
    }
  };

  /// [retrieveOrder] removes items from the cart, back to the shop
  void retrieveOrder(orderName, paymentType, items, discount, tax, color,
      isOpenTable, orderID, isCounterOrder, orderType, clientAssigned, client) {
    ticketItems['Order Name'] = orderName;
    ticketItems['Payment Type'] = paymentType;
    ticketItems['Items'] = items;
    ticketItems['Discount'] = discount;
    ticketItems['IVA'] = tax;
    ticketItems['Color'] = color;
    ticketItems['Open Table'] = isOpenTable;
    ticketItems['Counter Order'] = isCounterOrder;
    ticketItems['Order ID'] = orderID;
    ticketItems['Order Type'] = orderType;
    ticketItems['Client Assigned'] = clientAssigned;
    ticketItems['Client'] = client;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [changeOrderName] removes items from the cart, back to the shop
  void changeOrderName(orderName) {
    ticketItems['Order Name'] = orderName;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [changeOrderType] removes items from the cart, back to the shop
  void changeOrderType(orderType) {
    ticketItems['Order Type'] = orderType;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [changeTableStatus] removes items from the cart, back to the shop
  void changeTableStatus(isOpenTable) {
    ticketItems['Open Table'] = isOpenTable;

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
    ticketItems['Color'] = Colors.white;
    ticketItems['Open Table'] = false;
    ticketItems['Order ID'] = '';
    ticketItems['Counter Order'] = false;
    ticketItems['Order Type'] = 'Mostrador';
    ticketItems['Client Assigned'] = false;
    ticketItems['Client'] = {
      'Name': '',
      'Address': '',
      'Phone': 0,
      'email': '',
    };

    ticketStreamController.sink.add(ticketItems);
  }

  /// [addQuantity] adds items from the cart, back to the shop
  void addQuantity(i) {
    ticketItems['Items'][i]['Quantity'] =
        ticketItems['Items'][i]['Quantity'] + 1;
    ticketItems['Items'][i]['Total Price'] =
        ticketItems['Items'][i]['Price'] * ticketItems['Items'][i]['Quantity'];

    ticketStreamController.sink.add(ticketItems);
  }

  /// [removeQuantity] removes items from the cart, back to the shop
  void removeQuantity(i) {
    ticketItems['Items'][i]['Quantity'] =
        ticketItems['Items'][i]['Quantity'] - 1;
    ticketItems['Items'][i]['Total Price'] =
        ticketItems['Items'][i]['Price'] * ticketItems['Items'][i]['Quantity'];

    ticketStreamController.sink.add(ticketItems);
  }

  /// [editQuantity] adds items from the cart, back to the shop
  void editQuantity(i, q) {
    ticketItems['Items'][i]['Quantity'] = q;
    ticketItems['Items'][i]['Total Price'] =
        ticketItems['Items'][i]['Price'] * q;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [editCategory] adds items from the cart, back to the shop
  void editCategory(i, category) {
    ticketItems['Items'][i]['Category'] = category;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [editProduct] adds items from the cart, back to the shop
  void editProduct(i, product) {
    ticketItems['Items'][i]['Name'] = product;

    ticketStreamController.sink.add(ticketItems);
  }

  /// [editPrice] adds items from the cart, back to the shop
  void editPrice(i, price) {
    ticketItems['Items'][i]['Price'] = price;
    ticketItems['Items'][i]['Total Price'] =
        ticketItems['Items'][i]['Price'] * ticketItems['Items'][i]['Quantity'];

    ticketStreamController.sink.add(ticketItems);
  }

  //Edit Tax amount
  void setTaxAmount(double amount) {
    ticketItems['IVA'] = amount;
    ticketStreamController.sink.add(ticketItems);
  }

  void removeTaxAmount() {
    ticketItems['IVA'] = 0;
    ticketStreamController.sink.add(ticketItems);
  }

  //Edit Discount Amount
  void setDiscountAmount(double amount) {
    ticketItems['Discount'] = amount;

    ticketStreamController.sink.add(ticketItems);
  }

  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    ticketStreamController.close(); // close our StreamController
  }
}

final bloc = TicketBloc(); // add to the end of the file
