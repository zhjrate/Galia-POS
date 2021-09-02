import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class POSItemDialog extends StatefulWidget {
  final String product;
  final List<PriceOptions> priceOptions;
  final bool availableOnMenu;
  final double price;
  final String category;
  final String documentID;

  POSItemDialog(this.product, this.priceOptions, this.availableOnMenu,
      this.price, this.category, this.documentID);
  @override
  _POSItemDialogState createState() => _POSItemDialogState();
}

class _POSItemDialogState extends State<POSItemDialog> {
  bool isAvailable;
  bool changedAvailability;
  int quantity;
  double selectedPrice;
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  void initState() {
    isAvailable = widget.availableOnMenu;
    changedAvailability = false;
    quantity = 1;
    selectedPrice = widget.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
            width: 400,
            constraints: BoxConstraints(minHeight: 350),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Cancel Icon
                Container(
                  alignment: Alignment(1.0, 0.0),
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      iconSize: 20.0),
                ),
                SizedBox(height: 10),
                //Product
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.product,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
                //Price
                Container(
                  width: double.infinity,
                  child: Text(
                    '${formatCurrency.format(selectedPrice)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
                //Available
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Text
                      Text(
                        'Disponible',
                        style: TextStyle(
                            color: (isAvailable) ? Colors.black : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 10),
                      //Available Button
                      Switch(
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                            changedAvailability = true;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                //Price Options
                (widget.priceOptions.length == 0)
                    ? Container()
                    : Container(
                        width: double.infinity,
                        height: 35,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: widget.priceOptions.length,
                            itemBuilder: (context, x) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.hovered))
                                            return Colors.grey.shade300;
                                          if (states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed))
                                            return Colors.grey.shade300;
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedPrice =
                                            widget.priceOptions[x].price;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5.0),
                                      child: Center(
                                          child: Text(
                                        '${widget.priceOptions[x].option}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      )),
                                    )),
                              );
                            })),
                SizedBox(height: (widget.priceOptions.length == 0) ? 0 : 30),
                //Quantity
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Minus
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade300),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.grey.shade500;
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed))
                                return Colors.grey.shade500;
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          if (quantity <= 0) {
                            //
                          } else {
                            setState(() {
                              quantity = quantity - 1;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Icon(Icons.remove,
                                  color: Colors.black, size: 16)),
                        ),
                      ),
                      //Quantity
                      Container(
                          height: 50,
                          width: 50,
                          color: Colors.white,
                          child: Center(
                              child: Text(
                            '$quantity',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ))),
                      //More
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade300),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.grey.shade500;
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed))
                                return Colors.grey.shade500;
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            quantity = quantity + 1;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Center(
                              child: Icon(Icons.add,
                                  color: Colors.black, size: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                //Save Button
                Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.grey.shade500;
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.grey.shade500;
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        // Update Cart
                        if (quantity > 0) {
                          bloc.addToCart({
                            'Name': widget.product,
                            'Category': widget.category,
                            'Price': selectedPrice,
                            'Quantity': quantity,
                            'Total Price': selectedPrice * quantity
                          });
                        }
                        // Change Availability
                        if (changedAvailability) {
                          DatabaseService().updateProductAvailability(
                              widget.documentID, isAvailable);
                        }
                        // Go Back
                        Navigator.of(context).pop();
                      },
                      child: Center(
                          child: Text(
                        'Guardar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ))),
                ),
              ],
            )),
      ),
    );
  }
}
