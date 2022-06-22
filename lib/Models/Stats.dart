class MonthlyStats {
  int totalSales;
  int totalSalesCount;
  int totalItemsSold;
  Map<String, dynamic> salesCountbyProduct;
  Map<String, dynamic> salesAmountbyProduct;
  Map<String, dynamic> salesCountbyCategory;

  MonthlyStats(
      {this.totalSales,
      this.totalSalesCount,
      this.totalItemsSold,
      this.salesCountbyProduct,
      this.salesCountbyCategory,
      this.salesAmountbyProduct});
}
