class MonthlyStats {
  int totalSalesCount;
  int totalItemsSold;
  Map<String, dynamic> salesCountbyProduct;
  Map<String, dynamic> salesAmountbyProduct;
  Map<String, dynamic> salesCountbyCategory;

  MonthlyStats(
      {this.totalSalesCount,
      this.totalItemsSold,
      this.salesCountbyProduct,
      this.salesCountbyCategory,
      this.salesAmountbyProduct});
}
