import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/POS/PlateSelection_Desktop.dart';
import 'package:denario/POS/TicketView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class POSDesk extends StatefulWidget {
  @override
  _POSDeskState createState() => _POSDeskState();
}

class _POSDeskState extends State<POSDesk> {
  String category;
  List categories;

  @override
  void initState() {
    category = 'Café';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryList>(context);

    if (categoriesProvider == null) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Plate Selection
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //Category selection
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, i) {
                            return FlatButton(
                              color: Colors.grey.shade400,
                              hoverColor: Colors.grey[350],
                              height: 50,
                              onPressed: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Center(),
                              ),
                            );
                          }),
                    ),
                    Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 15,
                        endIndent: 15),
                    //Plates GridView
                    Expanded(
                        child: Container(
                            child: GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width > 1100) ? 5 : 3,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 1,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: 12,
                      itemBuilder: (context, i) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.black12;
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.black26;
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {},
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                          ),
                        );
                      },
                    )))
                  ],
                ),
              ),
            ),
            //Ticket View
            Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.25,
                constraints: BoxConstraints(minWidth: 300),
                decoration:
                    BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[200],
                    offset: new Offset(-15.0, 15.0),
                    blurRadius: 10.0,
                  )
                ]),
                child: Container())
          ],
        ),
      );
    }

    categories = categoriesProvider.categoriesList;

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Plate Selection
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //Category selection
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, i) {
                          return FlatButton(
                            color: (category == categories[i].category)
                                ? Colors.black
                                : Colors.transparent,
                            hoverColor: Colors.grey[350],
                            height: 50,
                            onPressed: () {
                              setState(() {
                                category = categories[i].category;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Center(
                                child: Text(
                                  categories[i].category,
                                  style: TextStyle(
                                      color:
                                          (category == categories[i].category)
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 15,
                      endIndent: 15),
                  //Plates GridView
                  Expanded(
                      child: Container(
                          child: StreamProvider<List<Products>>.value(
                              initialData: [],
                              value: DatabaseService().productList(category),
                              child:
                                  PlateSelectionDesktop(category: category)))),
                ],
              ),
            ),
          ),
          //Ticket View
          Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width * 0.25,
              constraints: BoxConstraints(minWidth: 300),
              decoration:
                  BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[200],
                  offset: new Offset(-15.0, 15.0),
                  blurRadius: 10.0,
                )
              ]),
              child: TicketView())
        ],
      ),
    );
  }
}
