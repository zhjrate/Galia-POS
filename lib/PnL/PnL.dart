import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PnL extends StatefulWidget {
  final List pnlAccountGroups;
  final Map<dynamic, dynamic> pnlMapping;

  PnL({this.pnlAccountGroups, this.pnlMapping});

  @override
  _PnLState createState() => _PnLState();
}

class _PnLState extends State<PnL> {
  Future currentValuesBuilt;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc('VTam7iYZhiWiAFs3IVRBaLB5s3m2')
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[200],
                    offset: new Offset(15.0, 15.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.pnlAccountGroups.length,
                itemBuilder: (context, i) {
                  //List of Group of Accounts (High Level Mapping)
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        //Account Group Text
                        Text(
                          widget.pnlAccountGroups[i],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 15),
                        //Sub Accounts
                        Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.all(5),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .pnlMapping['${widget.pnlAccountGroups[i]}']
                                  .length,
                              itemBuilder: (context, x) {
                                int itemAmount;

                                try {
                                  itemAmount = snapshot.data[widget.pnlMapping[
                                      widget.pnlAccountGroups[i]][x]];
                                } catch (e) {
                                  itemAmount = 0;
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    //Cuenta
                                    Text(
                                        '${widget.pnlMapping[widget.pnlAccountGroups[i]][x]}'),
                                    Spacer(),
                                    //Monto
                                    Text('\$$itemAmount'),
                                  ]),
                                );
                              }),
                        ),
                        //Total of Account Group
                      ]));
                },
                //List of Accounts inside group (PnL Mapping)
              ),
            );
          } else {
            return Center();
          }
        });
  }
}
