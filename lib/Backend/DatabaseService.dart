import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/Models/Sales.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:denario/Models/Stats.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // Product List from snapshot
  List<Products> _productListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Products(
          product: doc.data()['Product'] ?? '',
          price: doc.data()['Price'] ?? 0,
          category: doc.data()['Category'] ?? 0,
          image: doc.data()['Image'] ?? '',
          description: doc.data()['Description'] ?? '',
          priceOptions: (doc.data()['Price Options'] == null)
              ? []
              : doc.data()['Price Options'].map<PriceOptions>((item) {
                  return PriceOptions(
                    item['Option'] ?? '',
                    item['Price'] ?? 0,
                  );
                }).toList(),
          available: doc.data()['Available'] ?? false,
          milkOptions: doc.data()['MilkOptions'] ?? false,
          productID: doc.id,
        );
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Product Stream
  Stream<List<Products>> productList(String category) async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('Products')
        .doc(uid)
        .collection('Menu')
        .where('Category', isEqualTo: category)
        .snapshots()
        .map(_productListFromSnapshot);
  }

  //Make Product Availble/Unavailable
  Future updateProductAvailability(String productID, bool available) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance
        .collection('Products')
        .doc(uid)
        .collection('Menu')
        .doc(productID)
        .update({
      'Available': available,
    });
  }

  // Product List from snapshot
  List<SavedOrders> _savedOrderListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return SavedOrders(
          orderName: doc.data()['Order Name'] ?? '',
          subTotal: doc.data()['Subtotal'] ?? 0,
          total: doc.data()['Total'] ?? 0,
          tax: doc.data()['IVA'] ?? 0,
          discount: doc.data()['Discount'] ?? 0,
          orderColor: doc.data()['Color'] ?? 0,
          paymentType: doc.data()['Payment Type'] ?? '',
          orderDetail: doc.data()['Items'] ?? [],
          id: doc.data()['Document ID'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Product Stream
  Stream<List<SavedOrders>> orderList() async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection('Saved')
        .snapshots()
        .map(_savedOrderListFromSnapshot);
  }

  ///////////////////////// Order Management from Firestore //////////////////////////

  //Create Order
  Future createOrder(String year, String month, String transactionID, subTotal,
      discount, tax, total, orderDetail, orderName, paymentType) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Sales')
        .doc(transactionID)
        .set({
      'Account': 'Ventas',
      'Date': DateTime.now(),
      'Discount': discount,
      'IVA': tax,
      'Items': orderDetail,
      'Order Name': orderName,
      'Payment Type': paymentType,
      'Subtotal': subTotal,
      'Total': total,
    });
  }

  //Wastage Order
  Future createWastage(
    String year,
    String month,
    String transactionID,
    totalCost,
    totalSale,
    orderDetail,
  ) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Wastage and Employee Consumption')
        .doc('Wastage')
        .collection('History')
        .doc(transactionID)
        .set({
      'Date': DateTime.now(),
      'Items': orderDetail,
      'Total Cost': totalCost,
      'Total Sale': totalSale,
    });
  }

  //Save Wastage Details
  Future saveWastageDetails(String ticketConcept, Map wastageByCategory) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    if (ticketConcept == 'Desperdicios') {
      try {
        return await FirebaseFirestore.instance
            .collection('ERP')
            .doc(uid)
            .collection(year)
            .doc(month)
            .collection('Wastage and Employee Consumption')
            .doc('Wastage')
            .update(wastageByCategory);
      } catch (e) {
        return await FirebaseFirestore.instance
            .collection('ERP')
            .doc(uid)
            .collection(year)
            .doc(month)
            .collection('Wastage and Employee Consumption')
            .doc('Wastage')
            .set(wastageByCategory);
      }
    } else if (ticketConcept == 'Consumo de Empleados') {
      try {
        return await FirebaseFirestore.instance
            .collection('ERP')
            .doc(uid)
            .collection(year)
            .doc(month)
            .collection('Wastage and Employee Consumption')
            .doc('Employee Consumption')
            .update(wastageByCategory);
      } catch (e) {
        return await FirebaseFirestore.instance
            .collection('ERP')
            .doc(uid)
            .collection(year)
            .doc(month)
            .collection('Wastage and Employee Consumption')
            .doc('Employee Consumption')
            .set(wastageByCategory);
      }
    }
  }

  //Save Account/Category
  Future saveOrderType(Map salesByCategory) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    try {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .update(salesByCategory);
    } catch (e) {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .set(salesByCategory);
    }
  }

  //Save Stats Details
  Future saveOrderStats(Map orderStats) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    try {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .collection('Stats')
          .doc('Monthly Stats')
          .update(orderStats);
    } catch (e) {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .collection('Stats')
          .doc('Monthly Stats')
          .set(orderStats);
    }
  }

  //Save Order
  Future saveOrder(String transactionID, subTotal, discount, tax, total,
      orderDetail, orderName, paymentType, orderColor) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection('Saved')
        .doc(transactionID)
        .set({
      'Discount': discount,
      'IVA': tax,
      'Items': orderDetail,
      'Order Name': orderName,
      'Payment Type': paymentType,
      'Subtotal': subTotal,
      'Total': total,
      'Color': orderColor,
      'Document ID': transactionID,
    });
  }

  //Delete Saved Order
  Future deleteOrder(orderDoc) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection('Saved')
        .doc(orderDoc)
        .delete();
  }

  ///////////////////////// Master Data from Firestore //////////////////////////

  //Get High Level Mapping
  HighLevelMapping _highLevelMappingFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return HighLevelMapping(
          expenseInputMapping: snapshot.data()['Expense Input Mapping'],
          pnlAccountGroups: snapshot.data()['PnL Account Group Mapping'],
          pnlMapping: snapshot.data()['PnL Mapping'],
          expenseGroups: snapshot.data()['Expense Group Mapping']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //High Level Mapping Stream
  Stream<HighLevelMapping> highLevelMapping() async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection('Master Data')
        .doc('High Level Mapping')
        .snapshots()
        .map(_highLevelMappingFromSnapshot);
  }

  ///////////////////////// Expenses Data from Firestore //////////////////////////

  //Get Categories (Costo de Ventas)
  CategoryList _categoriesFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return CategoryList(
        categoriesList: snapshot.data()['Categories'].map<Categories>((item) {
          return Categories(
            category: item['Category'] ?? '',
            // products: item['Products'] ?? [],
            // vendors: item['Vendors'] ?? [],
          );
        }).toList(),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Categories Stream (Costo de Ventas)
  Stream<CategoryList> get categoriesList async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection('Master Data')
        .doc('Categories')
        .snapshots()
        .map(_categoriesFromSnapshot);
  }

  //Get Account Groups with Categories
  AccountsList _accountsFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return AccountsList(
          // costodeVentas:
          //     snapshot.data()['Costo de Ventas'].map<Categories>((item) {
          //   return Categories(
          //     category: item['Category'] ?? '',
          //     productDescription: item['Description'] ?? '',
          //     vendors: item['Vendors'] ?? [],
          //   );
          // }).toList(),
          // gastosdeEmpleados:
          //     snapshot.data()['Gastos de Empleados'].map<Categories>((item) {
          //   return Categories(
          //     category: item['Category'] ?? '',
          //     productDescription: item['Description'] ?? '',
          //     vendors: item['Vendors'] ?? [],
          //   );
          // }).toList(),
          // gastosdelLocal:
          //     snapshot.data()['Gastos del Local'].map<Categories>((item) {
          //   return Categories(
          //     category: item['Category'] ?? '',
          //     productDescription: item['Description'] ?? '',
          //     vendors: item['Vendors'] ?? [],
          //   );
          // }).toList(),
          // otrosGastos: snapshot.data()['Otros Gastos'].map<Categories>((item) {
          //   return Categories(
          //     category: item['Category'] ?? '',
          //     productDescription: item['Description'] ?? '',
          //     vendors: item['Vendors'] ?? [],
          //   );
          // }).toList(),
          accountsMapping: snapshot.data()['Account Mapping']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Accounts Stream
  Stream<AccountsList> get accountsList async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection('Master Data')
        .doc('Account Mapping')
        .snapshots()
        .map(_accountsFromSnapshot);
  }

  //Create Order
  Future saveExpense(costType, category, account, vendor, product, qty, price,
      total, paymentType) async {
    var date = DateTime.now();
    var orderNo = DateTime.now().toString();
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Expenses')
        .doc(orderNo)
        .set({
      'Fecha': date,
      'Cost Type': costType,
      'Account': account,
      'Category': category,
      'Vendor': vendor,
      'Product': product,
      'Quantity': qty,
      'Price': price,
      'Total': total,
      'Payment Type': paymentType,
    });
  }

  //Save Account/Category
  Future saveExpenseType(costType, category, account, amountCostType,
      amountAccount, amountCategory) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    try {
      if (account != "" && account != null) {
        return await FirebaseFirestore.instance
            .collection('ERP')
            .doc(uid)
            .collection(year)
            .doc(month)
            .update({
          costType: amountCostType,
          account: amountAccount,
          category: amountCategory,
        });
      } else {
        return await FirebaseFirestore.instance
            .collection('ERP')
            .doc(uid)
            .collection(year)
            .doc(month)
            .update({
          costType: amountCostType,
          category: amountCategory,
        });
      }
    } catch (e) {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .set({
        costType: amountCostType,
        account: amountAccount,
        category: amountCategory,
      });
    }
  }

  // Expense List from snapshot
  List<Expenses> _expensesFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Expenses(
          account: doc.data()['Account'] ?? '',
          category: doc.data()['Category'] ?? '',
          costType: doc.data()['Cost Type'] ?? '',
          date: doc.data()['Fecha'].toDate() ?? DateTime.now(),
          paymentType: doc.data()['Payment Type'] ?? '',
          price: doc.data()['Price'] ?? 0,
          product: doc.data()['Product'] ?? '',
          qty: doc.data()['Quantity'] ?? 0,
          total: doc.data()['Total'] ?? 0,
          vendor: doc.data()['Vendor'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Expense Stream
  Stream<List<Expenses>> expenseList(month, year) async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Expenses')
        .snapshots()
        .map(_expensesFromSnapshot);
  }

  /////////////////////////////////Cash Register ///////////////////////////

  //Open Cash Register
  Future openCashRegister(userName, initialAmount, DateTime date) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Daily')
        .doc('${date.toString()}')
        .set({
      'Fecha Apertura': date,
      'Fecha Cierre': date,
      'Usuario': userName,
      'Monto Inicial': initialAmount,
      'Abierto': true,
      'Transacciones del Día': 0,
      'Ventas': 0,
      'Ingresos': 0,
      'Egresos': 0,
      'Monto al Cierre': 0,
      'Ventas por Medio': [],
      'Detalle de Ingresos y Egresos': [],
      'Total Items Sold': 0,
      'Total Sales Count': 0,
      'Sales Count by Product': {},
      'Sales Count by Category': {},
      'Sales Amount by Product': {},
    });
  }

  Future recordOpenedRegister(bool openRegister, String registerID) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('ERP').doc(uid).update({
      'Caja Abierta': openRegister,
      'Caja Actual': registerID,
    });
  }

  //Update Cash Register (Inflows/Outflows)
  Future updateCashRegister(
      registerDate,
      String transactionType,
      double transactionAmount,
      double totalDailyTransactions,
      Map transactionDetails) async {
    DateTime date = DateTime.parse(registerDate);

    var year = date.year.toString();
    var month = date.month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    if (transactionDetails.isEmpty) {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .collection('Daily')
          .doc('$registerDate')
          .update({
        'Transacciones del Día': totalDailyTransactions,
        transactionType: transactionAmount
      });
    } else {
      return await FirebaseFirestore.instance
          .collection('ERP')
          .doc(uid)
          .collection(year)
          .doc(month)
          .collection('Daily')
          .doc('$registerDate')
          .update({
        'Transacciones del Día': totalDailyTransactions,
        transactionType: transactionAmount,
        'Detalle de Ingresos y Egresos':
            FieldValue.arrayUnion([transactionDetails])
      });
    }
  }

  //Update Cash Register (Inflows/Outflows)
  Future updateSalesinCashRegister(registerDate, double totalSales,
      List salesByMedium, double totalDailyTransactions) async {
    DateTime date = DateTime.parse(registerDate);
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    var year = date.year.toString();
    var month = date.month.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Daily')
        .doc('$registerDate')
        .update({
      'Transacciones del Día': totalDailyTransactions,
      'Ventas': totalSales,
      'Ventas por Medio': salesByMedium
    });
  }

  //Close Cash Register
  Future closeCashRegister(closeAmount, registerDate) async {
    DateTime date = DateTime.parse(registerDate);

    var year = date.year.toString();
    var month = date.month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Daily')
        .doc('$registerDate')
        .update({
      'Fecha Cierre': DateTime.now(),
      'Abierto': false,
      'Monto al Cierre': closeAmount,
    });
  }

  //Read Cash Register Status
  //Get First Level Cash Register Data
  CashRegister _cashRegisterFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return CashRegister(
          registerName: snapshot.data()['Caja Actual'],
          registerisOpen: snapshot.data()['Caja Abierta'],
          paymentTypes: snapshot.data()['Payment Types']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Categories Stream (Costo de Ventas)
  Stream<CashRegister> get cashRegisterStatus async* {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .snapshots()
        .map(_cashRegisterFromSnapshot);
  }

  //Get Daily Transactions
  DailyTransactions _dailyTransactionsFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return DailyTransactions(
          openDate: snapshot.data()['Fecha Apertura'].toDate(),
          closeDate: snapshot.data()['Fecha Cierre'].toDate(),
          user: snapshot.data()['Usuario'],
          initialAmount: snapshot.data()['Monto Inicial'],
          isOpen: snapshot.data()['Abierto'],
          dailyTransactions: snapshot.data()['Transacciones del Día'],
          sales: snapshot.data()['Ventas'],
          inflows: snapshot.data()['Ingresos'],
          outflows: snapshot.data()['Egresos'],
          closeAmount: snapshot.data()['Monto al Cierre'],
          salesByMedium: snapshot.data()['Ventas por Medio'],
          totalItemsSold: snapshot.data()['Total Items Sold'],
          totalSalesCount: snapshot.data()['Total Sales Count'],
          salesCountbyProduct: snapshot.data()['Sales Count by Product'],
          salesCountbyCategory: snapshot.data()['Sales Count by Category'],
          salesAmountbyProduct: snapshot.data()['Sales Amount by Product']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Daily  Stream (Costo de Ventas)
  Stream<DailyTransactions> dailyTransactions(String openRegister) async* {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Daily')
        .doc(openRegister)
        .snapshots()
        .map(_dailyTransactionsFromSnapshot);
  }

  // Daily Transactions List from snapshot
  List<DailyTransactions> _dailyTransactionsListFromSnapshot(
      QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return DailyTransactions(
            openDate: doc.data()['Fecha Apertura'].toDate(),
            closeDate: doc.data()['Fecha Cierre'].toDate(),
            user: doc.data()['Usuario'],
            initialAmount: doc.data()['Monto Inicial'],
            isOpen: doc.data()['Abierto'],
            dailyTransactions: doc.data()['Transacciones del día'],
            sales: doc.data()['Ventas'],
            inflows: doc.data()['Ingresos'],
            outflows: doc.data()['Egresos'],
            closeAmount: doc.data()['Monto al Cierre'],
            salesByMedium: doc.data()['Ventas por Medio'],
            totalItemsSold: doc.data()['Total Items Sold'],
            totalSalesCount: doc.data()['Total Sales Count'],
            salesCountbyProduct: doc.data()['Sales Count by Product'],
            salesCountbyCategory: doc.data()['Sales Count by Category'],
            salesAmountbyProduct: doc.data()['Sales Amount by Product']);
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Daily Transactions List Stream
  Stream<List<DailyTransactions>> dailyTransactionsList() async* {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Daily')
        .snapshots()
        .map(_dailyTransactionsListFromSnapshot);
  }

  //Save Stats Details
  Future saveDailyOrderStats(
      registerDate,
      int totalItemsSold,
      int totalSalesCount,
      Map salesCountbyProduct,
      Map salesCountbyCategory,
      Map salesAmountbyProduct) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Daily')
        .doc('$registerDate')
        .update({
      'Total Items Sold': totalItemsSold,
      'Total Sales Count': totalSalesCount,
      'Sales Count by Product': salesCountbyProduct,
      'Sales Count by Category': salesCountbyCategory,
      'Sales Amount by Product': salesAmountbyProduct,
    });
  }

  ///////////////////////// Sales Data from Firestore //////////////////////////

  // Sales List from snapshot
  List<Sales> _salesFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return Sales(
          account: doc.data()['Account'] ?? '',
          date: doc.data()['Date'].toDate() ?? DateTime.now(),
          discount: doc.data()['Discount'] ?? 0,
          tax: doc.data()['IVA'] ?? 0,
          soldItems: doc.data()['Items'].map<SoldItems>((item) {
                return SoldItems(
                  product: item['Name'] ?? '',
                  category: item['Category'] ?? '',
                  price: item['Price'] ?? 0,
                  qty: item['Quantity'] ?? 0,
                  total: item['Total Price'] ?? 0,
                );
              }).toList() ??
              [],
          orderName: doc.data()['Order Name'] ?? '',
          //orderID: doc.data()['Order'] ?? '',
          subTotal: doc.data()['Subtotal'] ?? 0,
          total: doc.data()['Total'] ?? 0,
          paymentType: doc.data()['Payment Type'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sales Stream
  Stream<List<Sales>> salesList() async* {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Sales')
        .where('Date',
            isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
        // .where('Payment Type', isEqualTo: 'Efectivo')
        // .where('Order Name', isEqualTo: '1')
        .snapshots()
        .map(_salesFromSnapshot);
  }

  //Stats from Snap
  Stream<MonthlyStats> monthlyStatsfromSnapshot() async* {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Stats')
        .doc('Monthly Stats')
        .snapshots()
        .map(_monthlyStats);
  }

  //Get Daily Transactions
  MonthlyStats _monthlyStats(DocumentSnapshot snapshot) {
    try {
      return MonthlyStats(
          totalSalesCount: snapshot.data()['Total Sales Count'],
          totalItemsSold: snapshot.data()['Total Items Sold'],
          salesCountbyProduct: snapshot.data()['Sales Count by Product'],
          salesAmountbyProduct: snapshot.data()['Sales Amount by Product'],
          salesCountbyCategory: snapshot.data()['Sales Count by Category']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
