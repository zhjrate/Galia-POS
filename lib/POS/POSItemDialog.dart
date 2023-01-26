import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

class POSItemDialog extends StatefulWidget {
  final String businessID;
  final String product;
  final List<ProductOptions> productOptions;
  final bool availableOnMenu;
  final double price;
  final String category;
  final String documentID;

  POSItemDialog(this.businessID, this.product, this.productOptions,
      this.availableOnMenu, this.price, this.category, this.documentID);
  @override
  _POSItemDialogState createState() => _POSItemDialogState();
}

class _POSItemDialogState extends State<POSItemDialog> {
  bool isAvailable;
  bool changedAvailability;
  int quantity;
  double selectedPrice;
  double basePrice;
  final formatCurrency = new NumberFormat.simpleCurrency();
  List selectedTags = [];

  double totalAmount(
    double basePrice,
    List selectedTags,
  ) {
    double total = 0;
    List<double> additionalsList = [];
    double additionalAmount = 0;

    //Serch for base price
    widget.productOptions.forEach((x) {
      if (x.priceStructure == 'Aditional') {
        for (var i = 0; i < x.priceOptions.length; i++) {
          if (selectedTags.contains(x.priceOptions[i]['Option'])) {
            additionalsList.add(x.priceOptions[i]['Price']);
          }
        }
      }
    });

    //Add up
    additionalsList.forEach((y) {
      additionalAmount = additionalAmount + y;
    });

    total = basePrice + additionalAmount;

    return total;
  }

  @override
  void initState() {
    isAvailable = widget.availableOnMenu;
    changedAvailability = false;
    quantity = 1;
    selectedPrice = widget.price;
    basePrice = widget.price;
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
                    '${formatCurrency.format(totalAmount(basePrice, selectedTags))}',
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
                (widget.productOptions.length == 0)
                    ? Container()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.productOptions.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Title
                                Text(
                                  widget.productOptions[i].title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 10),
                                //List
                                Container(
                                    width: double.infinity,
                                    child: Tags(
                                        itemCount: widget.productOptions[i]
                                            .priceOptions.length,
                                        itemBuilder: (int x) {
                                          return ItemTags(
                                              active: false,
                                              padding: EdgeInsets.all(12),
                                              key: Key(widget.productOptions[i]
                                                  .priceOptions[x]['Option']),
                                              index: x,
                                              singleItem: !widget
                                                  .productOptions[i]
                                                  .multipleOptions,
                                              title: widget.productOptions[i]
                                                  .priceOptions[x]['Option'],
                                              textColor: Colors.black,
                                              textActiveColor: Colors.white,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              activeColor:
                                                  Colors.greenAccent[400],
                                              onPressed: (item) {
                                                if (!selectedTags.contains(
                                                    widget.productOptions[i]
                                                            .priceOptions[x]
                                                        ['Option'])) {
                                                  //IF SINGLE CHOICE, REMOVE OTHERS
                                                  if (!widget.productOptions[i]
                                                      .multipleOptions) {
                                                    widget.productOptions[i]
                                                        .priceOptions
                                                        .forEach((x) {
                                                      if (selectedTags.contains(
                                                          x['Option'])) {
                                                        selectedTags.remove(
                                                            x['Option']);
                                                      }
                                                    });
                                                  }
                                                  //Add new
                                                  setState(() {
                                                    selectedTags.add(widget
                                                            .productOptions[i]
                                                            .priceOptions[x]
                                                        ['Option']);
                                                  });
                                                }

                                                if (widget.productOptions[i]
                                                            .priceStructure ==
                                                        'Aditional' &&
                                                    !selectedTags.contains(
                                                        widget.productOptions[i]
                                                                .priceOptions[x]
                                                            ['Option'])) {
                                                  setState(() {
                                                    selectedPrice = selectedPrice +
                                                        widget.productOptions[i]
                                                                .priceOptions[x]
                                                            ['Price'];
                                                  });
                                                } else if (widget
                                                        .productOptions[i]
                                                        .priceStructure ==
                                                    'Complete') {
                                                  setState(() {
                                                    basePrice = widget
                                                            .productOptions[i]
                                                            .priceOptions[x]
                                                        ['Price'];
                                                  });
                                                }
                                              });
                                        })),
                              ],
                            ),
                          );
                        }),

                SizedBox(height: (widget.productOptions.length == 0) ? 0 : 30),
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
                            'Price': totalAmount(basePrice, selectedTags),
                            'Quantity': quantity,
                            'Total Price':
                                totalAmount(basePrice, selectedTags) * quantity,
                            'Options': selectedTags
                          });
                        }
                        // Change Availability
                        if (changedAvailability) {
                          DatabaseService().updateProductAvailability(
                              widget.businessID,
                              widget.documentID,
                              isAvailable);
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
