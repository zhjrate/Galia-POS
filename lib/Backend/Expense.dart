import 'dart:async';

class ExpenseBloc {
  /// The [expenseStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final expenseStreamController = StreamController.broadcast();

  /// The [getExpenseStream] getter would be used to expose our stream to other classes
  Stream get getExpenseStream => expenseStreamController.stream;

  /// The [expenseItems] Map would hold all the data this bloc provides
  final Map expenseItems = {
    'Account': '',
    'Vendor': '',
    'Cost Type': '',
    'Payment Type': '',
    'Expense ID': '',
    'Items': [],
    'Total': 0,
  };

  /// [retrieveOrder] removes items from the cart, back to the shop
  void retrieveOrder(
      account, vendor, costtype, paymentType, items, expenseID, total) {
    expenseItems['Account'] = account;
    expenseItems['Vendor'] = vendor;
    expenseItems['Cost Type'] = costtype;
    expenseItems['Payment Type'] = paymentType;
    expenseItems['Expense ID'] = expenseID;
    expenseItems['Items'] = items;
    expenseItems['Total'] = total;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [changeVendor] removes items from the cart, back to the shop
  void changeVendor(vendor) {
    expenseItems['Vendor'] = vendor;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [changeCostType] removes items from the cart, back to the shop
  void changeCostType(costType) {
    expenseItems['Cost Type'] = costType;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [changeAccount] removes items from the cart, back to the shop
  void changeAccount(account) {
    expenseItems['Account'] = account;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [addToExpenseList] adds items from the shop to the cart
  void addToExpenseList(item) {
    expenseItems['Items'].add(item);
    expenseStreamController.sink.add(expenseItems);
  }

  /// [removeFromExpenseList] removes items from the cart, back to the shop
  void removeFromExpenseList(item) {
    expenseItems['Items'].remove(item);
    expenseStreamController.sink.add(expenseItems);
  }

  /// [removeAllFromExpense] removes items from the cart, back to the shop
  void removeAllFromExpense() {
    expenseItems['Account'] = '';
    expenseItems['Items'] = [];
    expenseItems['Vendor'] = '';
    expenseItems['Cost Type'] = '';
    expenseItems['Payment Type'] = '';
    expenseItems['Expense ID'] = '';
    expenseItems['Total'] = 0;
    expenseStreamController.sink.add(expenseItems);
  }

  /// [addQuantity] adds items from the cart, back to the shop
  void addQuantity(i) {
    expenseItems['Items'][i]['Quantity'] =
        expenseItems['Items'][i]['Quantity'] + 1;
    expenseItems['Items'][i]['Total Price'] = expenseItems['Items'][i]
            ['Price'] *
        expenseItems['Items'][i]['Quantity'];

    expenseStreamController.sink.add(expenseItems);
  }

  /// [removeQuantity] removes items from the cart, back to the shop
  void removeQuantity(i) {
    expenseItems['Items'][i]['Quantity'] =
        expenseItems['Items'][i]['Quantity'] - 1;
    expenseItems['Items'][i]['Total Price'] = expenseItems['Items'][i]
            ['Price'] *
        expenseItems['Items'][i]['Quantity'];

    expenseStreamController.sink.add(expenseItems);
  }

  /// [editQuantity] adds items from the cart, back to the shop
  void editQuantity(i, q) {
    expenseItems['Items'][i]['Quantity'] = q;
    expenseItems['Items'][i]['Total Price'] =
        expenseItems['Items'][i]['Price'] * q;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [editCategory] adds items from the cart, back to the shop
  void editCategory(i, category) {
    expenseItems['Items'][i]['Category'] = category;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [editProduct] adds items from the cart, back to the shop
  void editProduct(i, product) {
    expenseItems['Items'][i]['Name'] = product;

    expenseStreamController.sink.add(expenseItems);
  }

  /// [editPrice] adds items from the cart, back to the shop
  void editPrice(i, price) {
    expenseItems['Items'][i]['Price'] = price;
    expenseItems['Items'][i]['Total Price'] = expenseItems['Items'][i]
            ['Price'] *
        expenseItems['Items'][i]['Quantity'];

    expenseStreamController.sink.add(expenseItems);
  }

  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    expenseStreamController.close(); // close our StreamController
  }
}

final bloc = ExpenseBloc(); // add to the end of the file
