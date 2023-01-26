import 'package:denario/Models/Sales.dart';
import 'package:denario/Models/SavedOrders.dart';

class Clients {
  String name;
  String address;
  int phone;
  String email;
  List<Sales> history;
  List<SavedOrders> pending;

  Clients(this.name, this.address, this.phone, this.email, this.history,
      this.pending);
}
