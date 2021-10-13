class CategoryList {
  List<Categories> categoriesList;
  CategoryList({this.categoriesList});
}

class AccountsList {
  List<Categories> costodeVentas;
  List<Categories> gastosdeEmpleados;
  List<Categories> gastosdelLocal;
  List<Categories> otrosGastos;

  Map accountsMapping;

  AccountsList(
      {this.costodeVentas,
      this.gastosdeEmpleados,
      this.gastosdelLocal,
      this.otrosGastos,
      this.accountsMapping});
}

class Categories {
  String category;
  String productDescription;
  List products;
  List vendors;

  Categories(
      {this.category, this.products, this.vendors, this.productDescription});
}
