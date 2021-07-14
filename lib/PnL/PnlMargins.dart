import 'package:denario/PnL/GrossMarginGraph.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PnlMargins extends StatefulWidget {
  final double grossMargin;
  final double operatingMargin;
  final double profitMargin;
  final AsyncSnapshot snapshot;

  PnlMargins(
      {this.grossMargin,
      this.operatingMargin,
      this.profitMargin,
      this.snapshot});

  @override
  _PnlMarginsState createState() => _PnlMarginsState();
}

class _PnlMarginsState extends State<PnlMargins> {
  final formatter = new NumberFormat("#,###");

  Widget marginBox(String marginName, double marginPercentage,
      double marginNumber, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text
            Text(
              marginName,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            //Amount
            Text(
              '\$${formatter.format(marginNumber)}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey),
            ),
            SizedBox(height: 10),
            //Margin
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Number
                  Text(
                    '${marginPercentage.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                  ),
                  SizedBox(width: 5),
                  //%
                  Text(
                    '%',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ]),
          ]),
    );
  }

  double cafeVentas;
  double cafeCostos;
  double postresVentas;
  double postresCostos;
  double panVentas;
  double panCostos;
  double platosVentas;
  double platosCostos;
  double bebidasVentas;
  double bebidasCostos;
  double promosVentas;
  double otrosCostos;

  @override
  Widget build(BuildContext context) {
    try {
      cafeVentas = widget.snapshot.data['Ventas de Café'];
    } catch (e) {
      cafeVentas = 0;
    }
    try {
      cafeCostos = widget.snapshot.data['Costos de Café'];
    } catch (e) {
      cafeCostos = 0;
    }
    try {
      postresVentas = widget.snapshot.data['Ventas de Postres'];
    } catch (e) {
      postresVentas = 0;
    }
    try {
      postresCostos = widget.snapshot.data['Costos de Postres'];
    } catch (e) {
      postresCostos = 0;
    }
    try {
      panVentas = widget.snapshot.data['Ventas de Panadería'];
    } catch (e) {
      panVentas = 0;
    }
    try {
      panCostos = widget.snapshot.data['Costos de Panadería'];
    } catch (e) {
      panCostos = 0;
    }
    try {
      platosVentas = widget.snapshot.data['Ventas de Platos'];
    } catch (e) {
      platosVentas = 0;
    }
    try {
      platosCostos = widget.snapshot.data['Costos de Platos'];
    } catch (e) {
      platosCostos = 0;
    }
    try {
      bebidasVentas = widget.snapshot.data['Ventas de Bebidas'];
    } catch (e) {
      bebidasVentas = 0;
    }
    try {
      bebidasCostos = widget.snapshot.data['Costos de Bebidas'];
    } catch (e) {
      bebidasCostos = 0;
    }
    try {
      promosVentas = widget.snapshot.data['Ventas de Promos'];
    } catch (e) {
      promosVentas = 0;
    }
    try {
      otrosCostos = widget.snapshot.data['Otros Costos'];
    } catch (e) {
      otrosCostos = 0;
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Margins
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Gross Margin
                  marginBox('Gross Margin', widget.grossMargin, 1000, context),
                  Spacer(),
                  //Op. Margin
                  marginBox(
                      'Operating Margin', widget.operatingMargin, 900, context),
                  Spacer(),
                  //Profit Margin
                  marginBox('Profit Margin', widget.profitMargin, 550, context),
                ],
              ),
              SizedBox(height: 20),
              //Graph
              Container(
                width: double.infinity,
                height: 400,
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
                child: Center(
                    child: GrossMarginGraph(
                  cafeVentas: cafeVentas,
                  cafeCostos: cafeCostos,
                  postresVentas: postresVentas,
                  postresCostos: postresCostos,
                  panVentas: panVentas,
                  panCostos: panCostos,
                  platosVentas: platosVentas,
                  platosCostos: platosCostos,
                  bebidasVentas: bebidasVentas,
                  bebidasCostos: bebidasCostos,
                  promosVentas: promosVentas,
                  otrosCostos: otrosCostos,
                )),
              )
            ]),
      ),
    );
  }
}
