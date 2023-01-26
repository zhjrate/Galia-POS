class Supplier {
  String name;
  List searchName;
  int id;
  String email;
  int phone;
  String address;
  List products;
  List invoices;
  String predefinedAccount;
  String predefinedCategory;
  String initialExpenseDescription;
  List costTypeAssociated;
  String docID;

  Supplier(
      {this.name,
      this.searchName,
      this.id,
      this.email,
      this.phone,
      this.address,
      this.products,
      this.invoices,
      this.predefinedAccount,
      this.predefinedCategory,
      this.initialExpenseDescription,
      this.costTypeAssociated,
      this.docID});
}
