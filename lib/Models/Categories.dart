class CategoryList {

  List<Categories> categoriesList;
  CategoryList({this.categoriesList});

}

class AccountsList {

  List<Categories> gastosdeEmpleados;
  List<Categories> gastosdelLocal;
  List<Categories> otrosGastos;

  AccountsList({this.gastosdeEmpleados, this.gastosdelLocal, this.otrosGastos});

}

class Categories {

  String category;
  String productDescription;
  List products;
  List vendors;

  Categories({this.category, this.products, this.vendors, this.productDescription});

}