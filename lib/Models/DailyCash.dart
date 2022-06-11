class CashRegister {
  bool registerisOpen;
  String registerName;
  List paymentTypes;
  CashRegister({this.registerName, this.registerisOpen, this.paymentTypes});
}

class DailyTransactions {
  DateTime openDate;
  DateTime closeDate;
  String user;
  double initialAmount;
  bool isOpen;
  double dailyTransactions;
  double sales;
  double inflows;
  double outflows;
  double closeAmount;
  List salesByMedium;
  int totalItemsSold;
  int totalSalesCount;
  Map salesCountbyProduct;
  Map salesCountbyCategory;
  Map salesAmountbyProduct;

  DailyTransactions(
      {this.openDate,
      this.closeDate,
      this.user,
      this.initialAmount,
      this.isOpen,
      this.dailyTransactions,
      this.sales,
      this.inflows,
      this.outflows,
      this.closeAmount,
      this.salesByMedium,
      this.totalSalesCount,
      this.totalItemsSold,
      this.salesAmountbyProduct,
      this.salesCountbyCategory,
      this.salesCountbyProduct});
}
